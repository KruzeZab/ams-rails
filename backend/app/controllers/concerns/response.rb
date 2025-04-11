module Response
  def render_success(message: '', data: {}, status: :ok, meta: nil)
    response = {
      success: true,
      message: message,
      data: data
    }
    response[:meta] = meta if meta.present?
  
    render json: response, status: status
  end

  def render_error(message: '', errors: [], status: :unprocessable_entity)
    render json: {success: false, message: message, errors: errors}, status: status
  end
end
