class RemindEventStudentJob < ActiveJob::Base
  queue_as :default

  def perform(*args)

    event_applicant = EventApplicant.find(args[0])
    student = event_applicant.student

    if event_applicant.status == EventApplicant::S_APPROVE
      StudentMailer.event_will_do(event_applicant).deliver_now
      event_applicant.update_column(:remind_event_student_job_id, nil)
    end

  end

end