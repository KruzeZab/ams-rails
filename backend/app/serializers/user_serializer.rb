class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :phone, :gender, :dob, :address, :role, :artist

  def artist
    return nil if object.artist.nil?

    ArtistSummarySerializer.new(object.artist)
  end
end
