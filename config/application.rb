require_relative 'boot'

# Ransack
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'
require 'nkf'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Recmatch
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja

    config.generators do |g|
      g.helper false
      g.assets false
      g.system_tests nil
      g.test_framework :rspec, view_specs: false, helper_specs: false, controller_spec: false, request_spec: false, routing_spec: false
    end

    config.autoload_paths += %W(
      #{config.root}/lib
      #{config.root}/app/models/errors
      #{config.root}/app/models/socials
      #{config.root}/app/models/reports
      #{config.root}/app/models/questions
      #{config.root}/app/models/students
      #{config.root}/app/models/companies
      #{config.root}/app/models/projects
      #{config.root}/app/models/orders
      #{config.root}/app/models/csv
      #{config.root}/app/models/quits
      #{config.root}/app/models/identifications
      #{config.root}/app/models/books
      #{config.root}/app/models/aggregations
      #{config.root}/app/models/gcp
      #{config.root}/app/models/cancel_reasons
    )

    config.eager_load_paths += %W(
      #{config.root}/lib
    )

    config.browserify_rails.commandline_options = '-t envify -t babelify'

    unless Rails.env.development?
      config.react.variant = :production
    end

    #config.paths['config/routes.rb'].concat Dir[Rails.root.join('config/routes/**/*.rb')]
  end
end
