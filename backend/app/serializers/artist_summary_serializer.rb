class ArtistSummarySerializer < ActiveModel::Serializer
  attributes :id, :number_of_albums_released, :first_release_year
end
