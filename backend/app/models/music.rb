class Music < ApplicationRecord
  belongs_to :artist
  
  GENRES = { classic: 'classic', rock: 'rock', jazz: 'jazz', rnb: 'rnb', country: 'country' }.freeze

  validates :title, :album_name, presence: true
  validates :genre, presence: true, inclusion: { in: GENRES.values, message: "invalid" }
end
