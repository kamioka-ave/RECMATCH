class Offer < ApplicationRecord

  belongs_to :project
  belongs_to :student

  S_NEW = 0
  S_APPROVE = 1
  S_REJECT = 2


  belongs_to :project
  belongs_to :company
  has_one :project_meet, class_name: 'ProjectMeet', foreign_key: 'project_offer_id'

  validates :company_id, presence: true
  validates :student_id, presence: true
  validates :status, presence: true
  validates :description, presence: true
  validates :closing_date, presence: true

  def self.names_with_status
    {
      '受付完了' => S_NEW,
      '承認' => S_APPROVE,
      '拒否' => S_REJECT
    }
  end

  def self.names_with_offer_type
    {
      '採用選考'.to_sym => 0,
      'イベント'.to_sym => 1,
      '個別面談'.to_sym => 2,
      'その他'.to_sym => 3
    }
  end

end
