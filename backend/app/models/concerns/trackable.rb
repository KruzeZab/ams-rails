module Trackable
  extend ActiveSupport::Concern

  included do
    after_create  :log_create_activity
    before_update :store_changes_before_update
    after_update  :log_update_activity
    after_destroy :log_destroy_activity

    attr_accessor :current_user
  end

  private

  def log_create_activity
    ActivityLog.create!(
      user_id: current_user_id,
      action: "create",
      record_type: self.class.name,
      record_id: self.id,
      change_log: self.attributes.as_json
    )
  end

  def store_changes_before_update
    @tracked_changes = self.changes.transform_values(&:dup)
  end

  def log_update_activity
    return if @tracked_changes.blank?

    ActivityLog.create!(
      user_id: current_user_id,
      action: "update",
      record_type: self.class.name,
      record_id: self.id,
      change_log: @tracked_changes.except("updated_at")
    )
  end

  def log_destroy_activity
    ActivityLog.create!(
      user_id: current_user_id,
      action: "delete",
      record_type: self.class.name,
      record_id: self.id,
      change_log: self.attributes.as_json
    )
  end

  def current_user_id
    current_user&.id
  end
end
