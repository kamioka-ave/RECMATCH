class Notification::Pusher
  def initialize
    @fcm = FCM.new ENV['FCM_SERVER_KEY']
  end

  def push token, content
    @fcm.send_with_notification_key(token, content)
  end
end
