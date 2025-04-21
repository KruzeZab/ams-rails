require 'csv'
require 'bcrypt'

class Api::V1::ArtistsController < ApplicationController
  before_action :set_artist, only: [:show] 

  def index
    authorize Artist
    artists = Artist.includes(:user).order(created_at: :desc)
    
    paginated_response(artists, message: "Artists fetched successfully", serializer: ArtistSerializer)
  end  
  
  def show
    authorize @artist
    render_success(message: "Artist details fetched", data: ArtistSerializer.new(@artist))
  end 

  def upload
    authorize Artist
    file = params[:file]
    return render_error(message: 'No file uploaded', status: :bad_request) unless file.present?
  
    begin
      csv_rows = CSV.read(file.path, headers: true)
      users_data = []
      artists_data = []
      timestamp = Time.current
  
      csv_rows.each do |row|
        hashed_password = BCrypt::Password.create(row['password'])
  
        users_data << {
          first_name: row['first_name'],
          last_name: row['last_name'],
          email: row['email'],
          phone: row['phone'],
          gender: row['gender'],
          dob: row['dob'],
          address: row['address'],
          role: User::ROLES[:ARTIST],
          password_digest: hashed_password,
          created_at: timestamp,
          updated_at: timestamp
        }
  
        artists_data << {
          number_of_albums_released: row['number_of_albums_released'].to_i,
          first_release_year: row['first_release_year'].to_i,
          created_at: timestamp,
          updated_at: timestamp
        }
      end
  
      ActiveRecord::Base.transaction do
        inserted_users = User.insert_all!(users_data, returning: %w[id]).rows.map(&:first)
  
        inserted_users.each_with_index do |user_id, idx|
          artists_data[idx][:user_id] = user_id
        end
  
        Artist.insert_all!(artists_data)
      end
  
      render_success(message: "#{artists_data.size} artists successfully imported")
  
    rescue => e
      render_error(message: 'Invalid CSV data', status: :unprocessable_entity)
    end
  end

  def download
    authorize Artist
  
    artists = Artist.includes(:user).order(created_at: :desc)
  
    csv_data = CSV.generate(headers: true) do |csv|
      csv << [
        'first Name', 'last Name', 'Email', 'Phone', 'Gender', 'Dob', 'Address',
        'Number of Albums Released', 'First Release Year'
      ]
  
      artists.each do |artist|
        user = artist.user
        csv << [
          user.first_name, user.last_name, user.email, user.phone, user.gender,
          user.dob, user.address, artist.number_of_albums_released,
          artist.first_release_year
        ]
      end
    end
  
    send_data csv_data,
              filename: "artists_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv",
              type: 'text/csv'
  end
  
  private

  def set_artist
    @artist = Artist.find_by(id: params[:id])
    render_error(message: "Artist not found", status: :not_found) and return unless @artist
  end
end
