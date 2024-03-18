class AddBigqueryEventJob < ActiveJob::Base
  queue_as :low_priority

  def perform(*args)
    unless Rails.env.test?
      event = Ahoy::Event.find(args[0])
      client = BigqueryEvent.new
      client.insert(event)
    end
  end
end