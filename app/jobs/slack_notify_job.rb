class SlackNotifyJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    notifier = Slack::Notifier.new(Settings.slack.webhook_url, channel: Settings.slack.channel)
    notifier.ping(args[0])
  end
end
