class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :authorize_request

  def create
    if User.where(role: User::ROLES[:super_admin]).exists?
      return render_error(message: 'Super admin already exists.', status: :forbidden )
    end

    user = User.new(user_params.merge(role: User::ROLES[:super_admin]))

    if user.save
      render_success(message: 'User created successfully', data: user, status: :created)
    else
      render_error(message: "User creation failed", errors: user.errors.full_messages)
    end
  end

  private

  def user_params
    params.permit(
      :first_name, :last_name, :email, :phone, :password, :dob,
      :gender, :address
    )
  end
end
