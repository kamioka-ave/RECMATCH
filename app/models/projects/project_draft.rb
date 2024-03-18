class ProjectDraft < ApplicationRecord

  S_NEW = 0
  S_EDIT = 1
  S_JUDGE = 2
  S_BACK = 3
  S_ACTIVE = 4
  S_REJECTED = 5
  S_FINISH = 6

  include Draftable

  attr_accessor :comment, :staging_project_id
  attr_reader :clone_from_staging

  belongs_to :company
  has_one :user, through: :company
  has_one :profile, through: :user
  belongs_to :admin
  belongs_to :authorizer, class_name: 'Admin', foreign_key: :proposal_id
  #has_many :project_draft_categories, dependent: :destroy
  has_many :categories, through: :project_draft_categories
  #accepts_nested_attributes_for :project_draft_categories
  has_one :project
  has_many :project_histories
  #has_many :contract_images, class_name: 'Project::ContractImage', as: :projectable, dependent: :destroy
  #accepts_nested_attributes_for :contract_images, allow_destroy: true
  #has_many :company_presidents, class_name: 'Project::CompanyPresident', as: :projectable, dependent: :destroy
  #accepts_nested_attributes_for :company_presidents, allow_destroy: true

  mount_uploader :image, ProjectUploader
  #mount_uploader :president_image, ProfileUploader
  #mount_uploader :stamp, ImageUploader
  #mount_uploader :contract_attachment, FileUploader

  with_options on: :publish do |p|
    p.validates :name, presence: true, length: { maximum: 0xff }
    p.validates :short_description, presence: true, length: { maximum: 0xff }
    p.validates :image, presence: true
    #p.validates :short_description, presence: true, length: { maximum: 65535 }
    p.validates :salary, presence: true, length: { maximum: 65535 }
    p.validates :process_selection, presence: true, length: { maximum: 65535 }
    p.validates :selection_condition, presence: true, length: { maximum: 65535 }
    p.validates :entry_closed, presence: true
    #p.validates :student_assumption, presence: true, length: { maximum: 65535 }
    p.validates :recruit_kind, presence: true, length: { maximum: 65535 }
    p.validates :duty_station, presence: true, length: { maximum: 65535 }
    #p.validates :new_salary, presence: true
    #p.validates :allowance, presence: true, length: { maximum: 65535 }
    #p.validates :raise_salary, presence: true, length: { maximum: 65535 }
    #p.validates :reward, presence: true, length: { maximum: 65535 }
    #p.validates :holiday, presence: true, length: { maximum: 65535 }
    #p.validates :insurance, presence: true, length: { maximum: 65535 }
    p.validates :welfare_program, presence: true, length: { maximum: 65535 }
    #p.validates :company_event, presence: true, length: { maximum: 65535 }
    #p.validates :sex_ratio, presence: true
    #p.validates :trial_period, presence: true, length: { maximum: 65535 }
    #p.validates :other_welfare, presence: true, length: { maximum: 65535 }
    #p.validates :retired_ratio, presence: true
    #p.validates :sex_ratio_hired, presence: true
    #p.validates :continuous, presence: true
    #p.validates :old, presence: true
    #p.validates :training, presence: true, length: { maximum: 65535 }
    #p.validates :vacation, presence: true, length: { maximum: 65535 }
    #p.validates :childcare, presence: true, length: { maximum: 65535 }
    #p.validates :recruit_univ, presence: true, length: { maximum: 65535 }
    #p.validates :univ_depart, presence: true, length: { maximum: 65535 }
    p.validates :start_at, presence: true
    p.validates :end_at, presence: true
  end

  with_options on: :reject do |r|
    r.validates :comment, presence: true
  end

  before_update do
    self.revision += 1
  end

  after_update do
    save_history
  end

  after_create do
    save_history
  end

  def amount
    0
  end

  def save_history
    params = attributes.compact
    puts params
    params.delete('id')
    params.delete('created_at')
    params.delete('updated_at')
    history = ProjectHistory.new(params)
    history.project_draft_id = id
    history.image = image.file

    if president_image.present?
      history.president_image = president_image.file
    end

    history.save!
  end

  def self.names_with_status
    {
      '申込み済み' => S_NEW,
      '編集中' => S_EDIT,
      '審査中' => S_JUDGE,
      '差し戻し' => S_BACK,
      '公開' => S_ACTIVE,
      '却下' => S_REJECTED,
      '終了' => S_FINISH
    }
  end

  def publish!
    p = project.present? ? project : Project.new
    p.project_draft_id = id
    p = build_project(p)

    transaction do
      save!(validate: false)
      p.save!(validate: false)

      if company.issuer_id.nil?
        company.assign_issuer_id
        company.save!
      end

      #AdminMailer.project_approved(self, comment).deliver_later
    end
  end

  def pdf_contract?
    contract_before_type == CONTRACT_BEFORE_TYPE_PDF
  end

  def html_contract?
    contract_before_type == CONTRACT_BEFORE_TYPE_HTML
  end

  def build_project(project)
    project.company_id = company_id
    project.status = Project::S_ACTIVE
    project.name = name
    project.image = image
    project.interview_movie = interview_movie
    project.president_image = president_image
    project.president_description = president_description
    project.short_description = short_description
    project.description = description
    project.company_info = company_info
    project.number_hired = number_hired
    project.salary = salary
    project.process_selection = process_selection
    project.selection_condition = selection_condition
    project.entry_closed = entry_closed
    project.student_assumption = student_assumption
    project.recruit_kind = recruit_kind
    project.duty_station = duty_station
    project.new_salary = new_salary
    project.allowance = allowance
    project.raise_salary = raise_salary
    project.reward = reward
    project.holiday = holiday
    project.insurance = insurance
    project.welfare_program = welfare_program
    project.company_event = company_event
    project.sex_ratio = sex_ratio
    project.trial_period = trial_period
    project.other_welfare = other_welfare
    project.retired_ratio = retired_ratio
    project.sex_ratio_hired = sex_ratio_hired
    project.continuous = continuous
    project.old = old
    project.training = training
    project.vacation = vacation
    project.childcare = childcare
    project.recruit_univ = recruit_univ
    project.univ_depart = univ_depart
    project.start_at = start_at
    project.end_at = end_at
    project.created_at = created_at
    project.updated_at = updated_at

    #if president_image.present?
    #  project.president_image = president_image
    #end

    #if contract_attachment.present?
    #  project.contract_attachment = contract_attachment
    #end

    project
  end
end
