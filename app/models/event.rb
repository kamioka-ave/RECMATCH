class Event < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  attr_accessor :comment

  E_EXP = 0
  E_EXC = 1
  E_INTERN = 2
  E_OTH = 3

  E_NEW = 0
  E_EDIT = 1
  E_JUDGE = 2
  E_BACK = 3
  E_OPEN = 4
  E_REJECT = 5
  E_END = 6

  attr_reader :admin, :authorizer

  has_many :event_applicant
  belongs_to :prefecture
  belongs_to :company, class_name: 'Company', foreign_key: 'company_id'
  has_one :user, through: :company
  belongs_to :prefecture

  mount_uploader :image, EventUploader

  validates :title, presence: true
  validates :start, presence: true
  validates :end, presence: true

  with_options on: :publish do |p|
    p.validates :capacity, presence: true
    p.validates :prefecture_id, presence: true
    p.validates :address, presence: true
    p.validates :image, presence: true
    p.validates :event_type, presence: true
    p.validates :description, presence: true, length: { maximum: 65535 }
  end

  before_update do
    self.revision += 1
  end

  def amount
    0
  end

  after_create_commit do
    job = EventFinishJob.set(wait_until: self.end.end_of_day).perform_later(id)
    update_column(:finish_job_id , job.provider_job_id)
  end

  after_update_commit do
    if finish_job_id.present?
      EventFinishJob.cancel_by(provider_job_id: finish_job_id)
      update_column(:finish_job_id , nil)
    end
    job = EventFinishJob.set(wait_until: self.end.end_of_day).perform_later(id)
    update_column(:finish_job_id , job.provider_job_id)
  end

  def build_event(event)
    event.company_id = company_id
    event.status = Event::E_OPEN
    event.title = title
    event.image = image
    event.start = start
    event.capacity = capacity
    event.prefecture_id = prefecture_id
    event.address = address
    event.event_type = event_type
    event.description = description

    event
  end

  def self.names_with_status
    {
      '申込み済み' => E_NEW,
      '編集中' => E_EDIT,
      '審査中' => E_JUDGE,
      '修正依頼中' => E_BACK,
      '承認' => E_OPEN,
      '却下' => E_REJECT,
      '終了' => E_END
    }
  end

  def self.names_with_event_type
    {
      '会社説明会' => E_EXP,
      '社員交流会' => E_EXC,
      'インターン' => E_INTERN,
      'その他' => E_OTH
    }
  end

  def self.colors_with_event_type
    {
      '#5cb85c' => E_EXP,
      '#5bc0de' => E_EXC,
      '#F2994A' => E_INTERN,
      '#eee' => E_OTH
    }
  end

end
