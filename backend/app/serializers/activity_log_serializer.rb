class ActivityLogSerializer < ActiveModel::Serializer
  attributes :id, :action, :record_type, :record_id, :change_log, :created_at

  belongs_to :user, if: -> { object.user.present? }

  def change_log
    return unless object.change_log.is_a?(Hash)

    object.change_log.except(
      "password_digest",
      "created_at",
      "updated_at",
      "id"
    )
  end

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email
  end
end
