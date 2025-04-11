class User < ApplicationRecord
  has_secure_password

  ROLES = { super_admin: 'super_admin', artist_manager: 'artist_manager', artist: 'artist' }.freeze
  GENDERS = { MALE: 'm', FEMALE: 'f', OTHERS: 'o' }.freeze

  validates :role, presence: true, inclusion: { in: ROLES.values, message: "invalid" }
  validates :gender, presence: true, inclusion: { in: GENDERS.values, message: "invalid" }
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :first_name, :last_name, :dob, :address, presence: true
  validates :email, presence: true,
                  uniqueness: true,
                  format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email" }
  validates :phone, presence: true,
                    format: { with: /\A\d{10,}\z/, message: "must be a valid number with at least 10 digits" }

  has_one :artist, dependent: :destroy
end
