class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :number_of_albums_released, :first_release_year

  attribute :user do
    {
      id: object.user.id,
      first_name: object.user.first_name,
      last_name: object.user.last_name,
      email: object.user.email,
      phone: object.user.phone,
      gender: object.user.gender,
      dob: object.user.dob,
      address: object.user.address,
      role: object.user.role
    }
  end
end
