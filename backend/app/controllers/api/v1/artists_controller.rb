class Api::V1::ArtistsController < ApplicationController
  before_action :set_artist, only: [:show]

  def create
    authorize artist
    artist = nil
  
    ActiveRecord::Base.transaction do
      user = User.create!(user_params.merge(role: User::ROLES[:ARTIST]))
      artist = Artist.create!(artist_params.merge(user: user))
    end
  
    render_success(message: "Artist created successfully", data: ArtistSerializer.new(artist), status: :created)
  
  rescue ActiveRecord::RecordInvalid => e
    render_error(message: "Artist creation failed", errors: e.record.errors.full_messages)
  end  

  def index
    authorize artist
    artists = Artist.includes(:user).order(created_at: :desc)
    
    paginated_response(artists, message: "Artists fetched successfully", serializer: ArtistSerializer)
  end  
  
  def show
    authorize @artist
    render_success(message: "Artist details fetched", data: ArtistSerializer.new(@artist))
  end

  def Update
    authorize @artist
    artist = @user&.artist
  
    return render_error(message: "Artist not found", status: :not_found) unless artist
  
    ActiveRecord::Base.transaction do
      @user.update!(user_params)
      artist.update!(artist_params)
    end
  
    render_success(message: "Artist updated successfully", data: ArtistSerializer.new(artist))
  
  rescue ActiveRecord::RecordInvalid => e
    render_error(message: "Update failed", errors: e.record.errors.full_messages)
  end  

  private

  def set_artist
    user = User.find_by(id: params[:id])
    render_error(message: "User not found", status: :not_found) and return unless user
  
    @artist = user.artist
    render_error(message: "Artist not found", status: :not_found) unless @artist
  end

  def artist_params
    params.permit(:number_of_albums_released, :first_release_year)
  end

  def user_params
    params.permit(
      :first_name, :last_name, :email, :phone, :password, :dob,
      :gender, :address
    )
  end
end
