class ApplicationController < ActionController::API
  include Response

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
end
