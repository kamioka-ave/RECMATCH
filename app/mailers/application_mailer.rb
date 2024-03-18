class ApplicationMailer < ActionMailer::Base
  default(
    from: Rails.env.production? ? '"RECMATCH" <info@recmatch.co.jp>' : '"RECMATCH" <info@recmatch.co.jp>',
    'Message-ID': "#{SecureRandom.uuid}@recmatch.cco.jp"
  )

  protected

  def mail_with_tracking(user: user, mail_params: {}, track_extra: {})
    message_id = "#{SecureRandom.uuid}@recmatch.co.jp"
    track(
      user: user,
      extra: track_extra.merge(message_id: message_id)
    )
    mail(mail_params.merge('Message-ID': message_id))
  end
end
