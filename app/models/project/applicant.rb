class Project::Applicant < ApplicationRecord

  S_NEW = 0
  S_SELECTION = 1
  S_APPROVE = 2
  S_REJECTED = 3
  S_FINISH = 4

  belongs_to :project, counter_cache: true
  belongs_to :student
  has_one :project_meet, class_name: 'ProjectMeet', foreign_key: 'project_applicant_id'

  validates :project_id, presence: true
  validates :student_id, presence: true
  validates :status, presence: true

  def self.name_with_status
    {
      'オファー受付完了' => S_NEW,
      '選考中' => S_SELECTION,
      '承諾' => S_APPROVE,
      '却下' => S_REJECTED,
      '終了' => S_FINISH
    }
  end
end
