class MusicSerializer < ActiveModel::Serializer
  attributes :id, :title, :genre, :album_name, :artist_id
end
