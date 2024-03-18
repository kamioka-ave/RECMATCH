require 'exception_notification/rails'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  config.ignored_exceptions += %w{ActionController::InvalidCrossOriginRequest}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    not Rails.env.production? || Rails.env.staging?
  end

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  config.add_notifier(
    :email,
    email_prefix: '[ERROR] RECMATCH',
    sender_address: %{"RECMATCH" <noreply@recmatch.co.jp>},
    exception_recipients: %w{recmatch.system@gmail.com}
  )

  # Slack notifier
  if Rails.env.production?
    config.add_notifier(
      :slack,
      webhook_url: 'https://hooks.slack.com/services/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',
      channel: 'recmatch-bot'
    )
  elsif Rails.env.staging?
    config.add_notifier(
      :slack,
      webhook_url: 'https://hooks.slack.com/services/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',
      channel: 'recmatch-staging-bot'
    )
  end
end
