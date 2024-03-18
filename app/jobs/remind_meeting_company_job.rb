class RemindMeetingCompanyJob < ActiveJob::Base
  queue_as :default

  def perform(*args)

    project_meet = ProjectMeet.find(args[0])
    company = project_meet.company

    if project_meet.status == ProjectMeet::S_APPROVE
      CompanyMailer.meeting_will_do(project_meet).deliver_now
      project_meet.update_column(:remind_company_job_id, nil)
    end

  end

end
