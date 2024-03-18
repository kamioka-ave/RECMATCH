class Api::V1::MembersController < Api::V1::ApiController
  def unread_messages
    user = User.find params[:id]
    render json: user.unread_notifications.count, status: :ok
  end
end
