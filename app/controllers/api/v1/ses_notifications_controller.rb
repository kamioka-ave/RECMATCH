class Api::V1::SesNotificationsController < Api::V1::ApiController
  protect_from_forgery with: :null_session

  def create
    data = JSON.parse(request.raw_post)

    if data.key?('SubscribeURL')
      open(data['SubscribeURL'])
    elsif data.key?('Message')
      notification = JSON.load(data['Message'])
      if notification.key?('mail') && notification['mail'].key?('commonHeaders')
        message_id = notification['mail']['commonHeaders']['messageId']
        message = Ahoy::Message.where(message_id: message_id).order(id: :desc).first
        message&.apply_ses_notification!(notification)
      end
    end

    render json: {}, status: 200
  end
end