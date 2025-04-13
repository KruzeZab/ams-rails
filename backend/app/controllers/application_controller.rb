class ApplicationController < ActionController::API
  include Response
  include Pagy::Backend
  include Pundit::Authorization
  
  before_action :authorize_request

  def current_user
    @current_user
  end

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id])
    rescue StandardError => e
      render_error(message: "Unauthorized", errors: [e.message], status: :unauthorized)
    end
  end

  def paginated_response(collection, message: "Data fetched successfully", serializer: nil)
    pagy_data, records = pagy(collection)

    data = serializer ? ActiveModelSerializers::SerializableResource.new(records, each_serializer: serializer) : records

    render_success(
      message: message,
      data: data,
      meta: {
        current_page: pagy_data.page,
        total_pages: pagy_data.pages,
        total_count: pagy_data.count
      }
    )
  end
end
