class EventApplicant < ApplicationRecord

  S_NEW = 0
  S_SELECTION = 1
  S_APPROVE = 2
  S_REJECTED = 3
  S_FINISH = 4

  belongs_to :event
  belongs_to :student

  validates :event_id, presence: true
  validates :student_id, presence: true
  validates :status, presence: true

  after_update_commit do
    if status == S_APPROVE
      job = RemindEventStudentJob.set(wait_until: event.start.ago(1.days).noon).perform_later(id)
      update_column(:remind_event_student_job_id, job.provider_job_id)
    elsif status.in?([S_FINISH, S_REJECTED])
      if remind_event_student_job_id.present?
        RemindEventStudentJob.cancel_by(provider_job_id: remind_event_student_job_id)
        update_column(:remind_event_student_job_id, nil)
      end
    end
  end

  def self.name_with_status
    {
      '参加未確定' => S_NEW,
      '選考中' => S_SELECTION,
      '参加確定' => S_APPROVE,
      '満員' => S_REJECTED,
      '終了' => S_FINISH
    }
  end

  def self.name_with_company_status
      {
        '参加希望' => S_NEW,
        '検討中' => S_SELECTION,
        '参加確定' => S_APPROVE,
        '却下' => S_REJECTED,
        'イベント終了' => S_FINISH
      }
    end
end
