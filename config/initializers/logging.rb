if Rails.env.production? || Rails.env.staging?
  Rails.configuration.log_tags = [lambda { |request| request.cookies['_recmatch_session'] }]
end