class Artist < ApplicationRecord
  belongs_to :user

  validates :number_of_albums_released, presence: true,
                                        numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :first_release_year, presence: true,
                                 numericality: { only_integer: true, greater_than_or_equal_to: 1600, less_than_or_equal_to: Date.today.year }
end
