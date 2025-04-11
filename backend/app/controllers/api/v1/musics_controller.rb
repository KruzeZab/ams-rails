class Api::V1::MusicsController < ApplicationController
  before_action :set_music, only: [:show, :update, :destroy]

  def index
    musics = if params[:artist_id]
               Music.where(artist_id: params[:artist_id])
             else
               Music.all
             end

    render_success(message: "Musics fetched successfully", data: musics)
  end

  def show
    render_success(message: "Music details fetched", data: @music)
  end

  def create
    puts params[:artist_id].to_s + "==========================================================="
    artist = Artist.find_by(id: params[:artist_id])

    unless artist
      return render_error(message: "Artist not found", status: :not_found)
    end

    music = artist.musics.new(music_params)

    if music.save
      render_success(message: "Music created successfully", data: music, status: :created)
    else
      render_error(message: "Music creation failed", errors: music.errors.full_messages)
    end
  end

  def update
    if @music.update(music_params)
      render_success(message: "Music updated successfully", data: @music)
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
    @music = Music.find_by(id: params[:id])
    render_error(message: "Music not found", status: :not_found) unless @music
  end

  def music_params
    params.permit(:title, :genre, :album_name)
  end
end
