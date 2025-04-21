class ActivityLog < ApplicationRecord
  belongs_to :user, optional: true

  validates :action, presence: true
  validates :record_type, presence: true
  validates :record_id, presence: true

  def user_name
    user&.email || "guest"
  end
end
