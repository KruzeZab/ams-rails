class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :authorize_request, only: [:create_super_admin, :check_email]
  
  def create
    user = User.new(user_params)
    authorize user
  
    ActiveRecord::Base.transaction do
      if user.role == User::ROLES[:ARTIST]
        user.build_artist(artist_params)
  
        unless user.artist.valid?
          user.errors.merge!(user.artist.errors)
          raise ActiveRecord::Rollback
        end
      end
  
      if user.save
        render_success(message: "User created successfully", data: UserSerializer.new(user), status: :created)
      else
        raise ActiveRecord::Rollback
      end
    rescue
      render_error(message: "User creation failed", errors: formatted_errors(user.errors))
    end
  end

  def create_super_admin
    user = User.new(user_params.merge(role: User::ROLES[:SUPER_ADMIN]))

    if user.save
      render_success(message: 'User created successfully', data: UserSerializer.new(user), status: :created)
    else
      render_error(message: "User creation failed", errors: formatted_errors(user.errors))
    end
  end

  def index
    authorize User
  
    users = policy_scope(User).order(created_at: :desc)

    paginated_response(users, serializer: UserSerializer, message: "Users fetched successfully")
  end

  def show
    authorize @user
    render_success(
      message: "User details fetched",
      data: UserSerializer.new(@user)
    )
  end

  def update
    authorize @user
  
    ActiveRecord::Base.transaction do
      if @user.update(user_params)
        if artist_params.present?
          if @user.artist.present?
            @user.artist.update!(artist_params)
          else
            @user.create_artist!(artist_params)
          end
        elsif @user.artist.present?
          @user.artist.destroy!
        end
  
        render_success(
          message: "User updated successfully",
          data: UserSerializer.new(@user)
        )
      else
        raise ActiveRecord::Rollback, "User update failed"
      end
    end
  
  rescue ActiveRecord::Rollback => e
    render_error(message: "User update failed", errors: formatted_errors(@user.errors))
  rescue ActiveRecord::RecordInvalid => e
    render_error(message: "Update failed", errors: formatted_errors(e.record.errors))
  end
  

  def destroy
    authorize @user
    @user.destroy
    render_success(message: "User deleted successfully", data: {id: @user.id})
  end

  def check_email
    authorize User

    userExists = User.exists?(email: params[:email])

    if userExists
      render_error(message: 'Email already exists', errors: [], status: :bad_request)
    else
      render_success(message: 'Valid email', data: { exists: false }, status: :ok)
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render_error(message: "User not found", status: :not_found) unless @user
  end

  def user_params
    params.permit(
      :first_name, :last_name, :email, :phone, :password, :dob,
      :gender, :address, :role
    )
  end

  def artist_params
    return {} unless params[:artist].present?
    params.require(:artist).permit(:number_of_albums_released, :first_release_year)
  end
end
