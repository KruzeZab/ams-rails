class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :allow_only_artist_manager, only: [:create]
  skip_before_action :authorize_request, only: [:create_super_admin]
  
  def create
    user = User.new(user_params.merge(role: User::ROLES[:ARTIST_MANAGER]))

    if user.save
      render_success(message: "User created successfully", data: user, status: :created)
    else
      render_error(message: "User creation failed", errors: user.errors.full_messages)
    end
  end

  def create_super_admin
    if User.where(role: User::ROLES[:SUPER_ADMIN]).exists?
      return render_error(message: 'Super admin already exists.', status: :forbidden )
    end

    user = User.new(user_params.merge(role: User::ROLES[:SUPER_ADMIN]))

    if user.save
      render_success(message: 'User created successfully', data: user, status: :created)
    else
      render_error(message: "User creation failed", errors: user.errors.full_messages)
    end
  end

  def index
    users = User.all
    render_success(message: "Users fetched successfully", data: users)
  end

  def show
    render_success(message: "User details fetched", data: @user)
  end

  def update
    if @user.update(user_params)
      render_success(message: "User updated successfully", data: @user)
    else
      render_error(message: "User update failed", errors: @user.errors.full_messages)
    end
  end

  def destroy
    @user.destroy
    render_success(message: "User deleted successfully", data: {id: @user.id})
  end


  private

  def allow_only_artist_manager
    if params[:role].to_s != User::ROLES[:ARTIST_MANAGER]
      return render_error(message: "Cannot perform the action", status: :forbidden)
    end
  end

  def set_user
    @user = User.find_by(id: params[:id])
    render_error(message: "User not found", status: :not_found) unless @user
  end

  def user_params
    params.permit(
      :first_name, :last_name, :email, :phone, :password, :dob,
      :gender, :address
    )
  end
end
