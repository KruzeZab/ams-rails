class Api::V1::ActivityLogsController < ApplicationController
  VALID_ACTION_TYPES = %w[create update delete]

  def index
    logs = ActivityLog.all
    logs = logs.where(action: params[:action_type]) if params[:action_type].present?
    logs = logs.order(created_at: :desc).includes(:user)
  
    paginated_response(logs, message: "Activity logs fetched successfully", serializer: ActivityLogSerializer)
  end

  private
  
  def validate_action_type_param
    return if params[:action_type].blank?

    unless VALID_ACTION_TYPES.include?(params[:action_type])
      render_error(message: "Invalid action_type. Allowed values: create, update, delete", status: :bad_request)
    end
  end
end
