module Response
  def render_success(message: nil, data: {}, status: :ok)
    response = { success: true }
    response[:message] = message if message.present?
    response[:data] = data if data.present?

    render json: response, status: status
  end

  def render_error(message: nil, errors: [], status: :unprocessable_entity)
    response = { success: false }
    response[:message] = message if message.present?
    response[:errors] = errors if errors.any?

    render json: response, status: status
  end
end
