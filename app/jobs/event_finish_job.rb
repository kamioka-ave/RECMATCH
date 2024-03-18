class EventFinishJob < ActiveJob::Base
  queue_as :default

  def perform(*args)

    event = Event.find(args[0])

    if event.status != Event::E_END && event.end <= Time.zone.now
      event.status = Event::E_END
      event.save!
      event.update_column(:finish_job_id, nil)
    end

  end

end