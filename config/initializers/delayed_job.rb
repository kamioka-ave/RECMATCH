Delayed::Worker.max_run_time = 8.hours
Delayed::Worker.queue_attributes = {
  default:       { priority: 11 },
  high_priority: { priority: 1 },
  low_priority:  { priority: 75 }
}

[[ExceptionNotifier, :notify_exception]].each do |object, method_name|
  raise NoMethodError, "undefined method `#{method_name}' for #{object.inspect}" unless object.respond_to?(method_name, true)
end

Delayed::Worker.class_eval do
  def handle_failed_job_with_notification(job, error)
    handle_failed_job_without_notification(job, error)
    begin
      ExceptionNotifier.notify_exception(error)
    rescue Exception => e
      Rails.logger.error "ExceptionNotifier failed: #{e.class.name}: #{e.message}"
      e.backtrace.each do |f|
        Rails.logger.error("  #{f}")
      end
      Rails.logger.flush
    end
  end

  alias_method :handle_failed_job_without_notification, :handle_failed_job
  alias_method :handle_failed_job, :handle_failed_job_with_notification
end