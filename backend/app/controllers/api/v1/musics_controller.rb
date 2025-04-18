class Api::V1::MusicsController < ApplicationController
  before_action :set_music, only: [:show, :update, :destroy]

  def index
    musics = if params[:artist_id]
               Music.includes(:artist).where(artist_id: params[:artist_id])
             else
               Music.includes(:artist).all
             end.order(created_at: :desc)
  
    paginated_response(musics, serializer: MusicSerializer, message: "Musics fetched successfully")
  end

  def show
    render_success(
      message: "Music details fetched",
      data: MusicSerializer.new(@music)
    )
  end

  def create
    artist = Artist.find_by(id: params[:artist_id])

    return render_error(message: "Artist not found", status: :not_found) unless artist

    music = artist.musics.new(music_params)
    authorize music

    if music.save
      render_success(message: "Music created successfully", data: MusicSerializer.new(music), status: :created)
    else
      render_error(message: "Music creation failed", errors: music.errors.full_messages)
    end
  end

  def update
    if @music.update(music_params)
      render_success(message: "Music updated successfully", data: MusicSerializer.new(@music))
    else
      render_error(message: "Music update failed", errors: @music.errors.full_messages)
    end
  end

  def destroy
    @music.destroy
    render_success(message: "Music deleted successfully", data: { id: @music.id })
  end

  private

  def set_music
    @music = Music.includes(:artist).find_by(id: params[:id])
    render_error(message: "Music not found", status: :not_found) unless @music
  end

  def music_params
    params.permit(:title, :genre, :album_name, :artist_id)
  end
end
