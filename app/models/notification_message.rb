class NotificationMessage
  def initialize message, receiver
    @message = message
    @receiver = receiver
  end

  def to_json
    redirect_url =
      if @receiver.member.is_a?(Company)
        Rails.application.routes.url_helpers.mypage_company_group_chat_category_path(@message.group_chat.category)
      else
        Rails.application.routes.url_helpers.mypage_supporter_company_group_chat_category_path(@message.group_chat.company, @message.group_chat.category)
      end

    {
      collapse_key: "notifications",
      data: {
        notification: {
          body: @receiver.member.notify_message(@message),
          icon: ActionController::Base.helpers.image_path('icon/favicon-96x96.png'),
          redirect_url: redirect_url
        }
      },
      webpush: {
        headers: {
          TTL: 60
        }
      }
    }
  end
end
