class User < ApplicationRecord
  has_secure_password

  has_one :artist, dependent: :destroy

  ROLES = { SUPER_ADMIN: 'super_admin', ARTIST_MANAGER: 'artist_manager', ARTIST: 'artist' }.freeze
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

  def super_admin?
    role == ROLES[:SUPER_ADMIN]
  end

  def artist_manager?
    role == ROLES[:ARTIST_MANAGER]
  end

  def artist?
    role === ROLES[:ARTIST]
  end
end
