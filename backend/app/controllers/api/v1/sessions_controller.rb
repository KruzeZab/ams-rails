class Api::V1::SessionsController < ApplicationController
  skip_before_action :authorize_request

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      payload = {
        user_id: user.id,
        role: user.role,
        email: user.email,
        full_name: "#{user.first_name} #{user.last_name}"
      }
      
      token = JsonWebToken.encode(payload)

      render_success(message: "Login successful", data: { token: token, user: user })
    else
      render_error(message: "Invalid email or password")
    end
  end
end
