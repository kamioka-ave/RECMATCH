class Api::V1::GroupChatsController < Api::V1::ApiController
  before_action :authenticate_user!

  def send_message
    group_chat = GroupChat.find params[:id]
    message = group_chat.messages.build(message_params)
    message.meta_data = JSON.parse message_meta_data[:meta_data]
    if message.save
      render json: message, status: 200
    else
      render errors: message.errors, status: 400
    end
  end

  def messages
    group_chat = GroupChat.find params[:id]
    messages = group_chat.messages.reverse_page(params[:page])
    render json: messages, status: 200
  end

  def attachments
    group_chat = GroupChat.find params[:id]
    attachments = group_chat.messages.attachment_message.page(params[:page])
    render json: {attachments: attachments, meta: pagination_dict(attachments)}, status: :ok
  end

  def mark_all_as_read
    group_chat = GroupChat.find params[:id]
    member = group_chat.members.find_by!(
      member_id: params[:member_id],
      member_type: params[:member_type]
    )
    group_chat.mark_all_as_read_for(member.member)
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :sender_type, :body, :attachment)
  end

  def message_meta_data
    params.require(:message).permit(:meta_data)
  end
end
