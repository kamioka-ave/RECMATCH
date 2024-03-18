class RemindMeetingStudentJob < ActiveJob::Base
  queue_as :default

  def perform(*args)

    project_meet = ProjectMeet.find(args[0])
    student = project_meet.student

    if project_meet.status == ProjectMeet::S_APPROVE
      StudentMailer.meeting_will_do(project_meet).deliver_now
      project_meet.update_column(:remind_student_job_id, nil)
    end

  end

end