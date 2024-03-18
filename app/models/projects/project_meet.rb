class ProjectMeet < ApplicationRecord

  S_MATCH = 0
  S_CONTACT = 1
  S_CANCEL = 2
  S_APPROVE = 3
  S_FINISH = 4
  S_ADJUST = 5

  belongs_to :project, class_name: 'Project', foreign_key: 'project_id'
  belongs_to :student, class_name: 'Student', foreign_key: 'student_id'
  belongs_to :company, class_name: 'Company', foreign_key: 'company_id'
  belongs_to :applicant, class_name: 'Project::Applicant', dependent: :destroy
  belongs_to :offer, class_name: 'Offer', dependent: :destroy

  validates :project_id, presence: true
  validates :student_id, presence: true
  validates :status, presence: true
  #validate :check_date if :start.present?

  #def check_date
  #  if :end  < :start
  #    errors.add(:end, '終了日時は開始日時より後の日付を設定してください。')
  #  elsif Time.now < :start && Time.now < :end
  #    errors.add(:start, '本日以降の日付を設定してください。')
  #  end
  #end

  after_update_commit do
    if status == S_APPROVE
      job = RemindMeetingCompanyJob.set(wait_until: start.ago(1.days).noon).perform_later(id)
      update_column(:remind_company_job_id, job.provider_job_id)
      job = RemindMeetingStudentJob.set(wait_until: start.ago(1.days).noon).perform_later(id)
      update_column(:remind_student_job_id, job.provider_job_id)
    elsif status.in?([S_CANCEL, S_FINISH, S_ADJUST])
      if remind_company_job_id.present?
        RemindMeetingCompanyJob.cancel_by(provider_job_id: remind_company_job_id)
        update_column(:remind_company_job_id, nil)
      end
      if remind_student_job_id.present?
        RemindMeetingStudentJob.cancel_by(provider_job_id: remind_student_job_id)
        update_column(:remind_student_job_id, nil)
      end
    end
  end

  def self.name_with_status
    {
      'マッチング成立中' => S_MATCH,
      '調整依頼中' => S_CONTACT,
      '再調整中' => S_ADJUST,
      'キャンセル' => S_CANCEL,
      '面談成立' => S_APPROVE,
      '終了' => S_FINISH
    }
  end

end
