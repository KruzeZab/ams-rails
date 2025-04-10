class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id, role: user.role)
      render_success(message: "Login successful", data: { token: token, user: user })
    else
      render_error(message: "Invalid email or password")
    end
  end
end
