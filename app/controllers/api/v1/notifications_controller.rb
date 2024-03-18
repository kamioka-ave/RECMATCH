class Api::V1::NotificationsController < Api::V1::ApiController
  def index
    user = User.find params[:member_id]
    notifications = user.messages.includes(company_members: [:member], sender: [profile: [user: :user_connections]]).order(created_at: :desc).page(params[:page])
    render json: { notifications: notifications.as_json(notification_message: true),
                  group_chat_members: user.group_chat_members,
                  meta: pagination_dict(notifications) }, status: :ok
  end
end
