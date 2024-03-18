module MessagesHelper
  def message_profile(conversation, current_user_id)
    if conversation.last_sender.id == current_user_id
      conversation.last_message.recipients.first.profile
    else
      conversation.last_sender.profile
    end
  end

  def body_as_html(message)
    message.body.gsub(/\[FILE\/\]/, "<div class='attachment' id='attachment-#{message.id}'<a>#{message.attachment.file.filename || message.attachment.url.split("/").last}</a></div>")
  end
end
