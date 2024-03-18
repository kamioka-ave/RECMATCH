Rails.application.configure do

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.log_level = :debug
  config.session_store :active_record_store, key: '_recmatch_session'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    host: 'localhost:3000'
  }
  ActionMailer::Base.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'gmail.com',
    authentication: 'plain',
    user_name: 'kami5330.key@gmail.com',
    password: 'kami11272496'
  }
  config.after_initialize do
    Bullet.enable = false
    Bullet.alert = false
    Bullet.bullet_logger = false
    Bullet.console = false
    Bullet.rails_logger = false
    Bullet.add_footer = false
  end
  config.active_job.queue_adapter = :delayed_job
  config.action_controller.default_url_options = { host: 'localhost:3000' }
end
CarrierWave.configure do |config|
  if ENV['ASSET_HOST']
    config.asset_host = ENV['ASSET_HOST']
    config.root = Rails.root
  else
    config.asset_host = 'http://localhost:3000'
  end

end