class Api::V1::ArtistsController < ApplicationController
  before_action :set_artist, only: [:show]

  def create
    ActiveRecord::Base.transaction do
      user = User.create!(user_params.merge(role: User::ROLES[:artist]))
      artist = Artist.create!(artist_params.merge(user: user))

      render_success(message: "Artist created successfully", data: artist, status: :created)

    rescue ActiveRecord::RecordInvalid => e
      render_error(message: "Artist creation failed", errors: [e.record.errors.full_messages])
    end
  end

  def index
    artists = Artist.includes(:user).all
  
    artist_data = artists.map do |artist|
      artist.attributes.merge(artist.user.slice(
        :id, :first_name, :last_name, :email, :phone, :gender, :dob, :address, :role
      ))
    end
  
    render_success(message: "Artists fetched successfully", data: artist_data)
  end
  

  def show
    user_data = @artist.user.slice(:id, :first_name, :last_name, :email, :phone, :gender, :dob, :address)
    artist_data = @artist.attributes.merge(user_data)
  
    render_success(message: "Artist details fetched", data: artist_data)
  end
  

  def update
    user = User.find_by(id: params[:id])
    artist = user&.artist
  
    return render_error(message: "User not found", status: :not_found) unless user
    return render_error(message: "Artist not found", status: :not_found) unless artist
  
    ActiveRecord::Base.transaction do
      user.update!(user_params)
      artist.update!(artist_params)
  
      render_success(message: "Artist updated successfully", data: artist)
    rescue ActiveRecord::RecordInvalid => e
      render_error(message: "Update failed", errors: e.record.errors.full_messages)
    end
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
