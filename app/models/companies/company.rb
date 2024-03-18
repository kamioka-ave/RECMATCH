# coding: utf-8
class Company < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  include Company::Ransackable

  S_BASICS = 0
  S_DETAILS = 1
  S_DOCUMENTS = 2
  S_APPLIED = 3
  S_ACTIVE = 4
  S_REJECTED = 5
  S_TEMP_ACTIVE = 6

  E_IPO = 0
  E_BUYOUT = 1
  E_OTHERS = 2

  attr_accessor :reject_mail

  belongs_to :user
  belongs_to :prefecture
  belongs_to :business_type, class_name: 'CompanyBusinessType', foreign_key: 'business_type_id'
  belongs_to :creator, class_name: 'Admin', foreign_key: 'creator_id'
  belongs_to :identifier, class_name: 'Admin', foreign_key: 'identifier_id'
  belongs_to :antisocial_checker, class_name: 'Admin', foreign_key: 'antisocial_checker_id'
  belongs_to :approver, class_name: 'Admin', foreign_key: 'approver_id'

  has_one :profile, through: :user
  has_one :agreement, class_name: 'CompanyAgreement', foreign_key: 'company_id', dependent: :destroy
  has_one :proposal, dependent: :destroy
  has_one :project, dependent: :destroy
  has_many :offers, class_name: 'Offer', dependent: :destroy

  has_many :user_connections, through: :user
  has_many :offers, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :admin_companies, dependent: :destroy
  has_many :admins, through: :admin_companies
  has_many :company_balance_sheets, dependent: :destroy
  has_many :status_histories, class_name: 'CompanyStatusHistory', dependent: :destroy

  validates :name, presence: true, unless: -> { validation_context == :reject }
  validates :name_kana, presence: true, unless: -> { validation_context == :reject }
  validates :president_first_name, presence: true, unless: -> { validation_context == :reject }
  validates :president_first_name_kana, presence: true, unless: -> { validation_context == :reject }
  validates :president_last_name, presence: true, unless: -> { validation_context == :reject }
  validates :president_last_name_kana, presence: true, unless: -> { validation_context == :reject }
  #validates :website, presence: true, unless: -> { validation_context == :reject }
  validates :image, presence: true, unless: -> { validation_context == :reject }
  #validates :president_birth_on, presence: true, unless: -> { validation_context == :reject }
  validates :zip_code, presence: true, unless: -> { validation_context == :reject }
  validates :city, presence: true, unless: -> { validation_context == :reject }
  validates :address1, presence: true, unless: -> { validation_context == :reject }
  validates :phone, presence: true, unless: -> { validation_context == :reject }
  validates :employees, presence: true, unless: -> { validation_context == :reject }
  validates :capital, presence: true, unless: -> { validation_context == :reject }, :numericality => { :less_than => 1000000000000000 }
  validates :sales_profit, presence: true, unless: -> { validation_context == :reject }, :numericality => { :less_than => 1000000000000000 }
  validates :business_type_id, presence: true, unless: -> { validation_context == :reject }
  validates :birth_on, timeliness: { before: Date.today }, allow_blank: true, unless: -> { validation_context == :reject }

  with_options on: :company_detail do |d|
    #d.validates :this_year_employments, presence: true
    #d.validates :last_year_employments, presence: true
    d.validates :business_summary, presence: true
    #d.validates :business_philosophy, presence: true
    d.validates :hope, presence: true
    #d.validates :business_shebang, presence: true
    #d.validates :competitive_strength, presence: true
    #d.validates :competitive_difference, presence: true
    #d.validates :target, presence: true
    #d.validates :ceo_hopes, presence: true
  end

  with_options on: :funding_agreement do |a|
    a.validates :agree_with_clause, acceptance: true
    a.validates :agree_with_pre_judge, acceptance: true
  end

  with_options on: :reject do |r|
    r.validates :reject_reason, presence: true
  end

  mount_uploader :image, ProfileUploader
  mount_uploader :image_draft, ProfileUploader

  acts_as_paranoid
  acts_as_messageable

  enum chat_toggle: { off: 0, on: 1 }, _prefix: :chat

  after_save do
    if saved_change_to_status? || saved_change_to_is_identification_passed? || saved_change_to_is_antisocial_check_passed? || saved_change_to_reject_reason?
      save_status_history
    end
  end

  scope :supported_by, ->(supporter) do
    joins(:supporters)
      .where(supporters: {id: supporter.id})
      .distinct
  end

  scope :message_count_with, ->(supporter) do
    joins(:company_supporter_messages)
      .where(company_supporter_messages: {sender: supporter})
      .group(:id)
      .select(:id, 'COUNT(company_supporter_messages.id) AS message_count')
  end

  def notify_message message
    if (message.mentioned_members & self.members).any?
      I18n.t('notification.company_mention', user_name: message.sender_name, category_name: message.group_chat.name)
    else
      I18n.t('notification.company_message', user_name: message.sender_name, category_name: message.group_chat.name)
    end
  end

  def self.names_with_stage
    {
      シリーズA: 1,
      シリーズB: 2,
      シリーズC: 3,
      シリーズD: 4
    }
  end

  def self.names_with_how_to_exit
    {
      IPO: E_IPO,
      バイアウト: E_BUYOUT,
      その他: E_OTHERS
    }
  end

  def self.names_with_capital_ties
    {
      有り: true,
      無し: false
    }
  end

  def self.names_with_status
    {
      '入力中（基本情報）' => S_BASICS,
      '入力中（詳細情報）' => S_DETAILS,
      '入力中（事前審査書類）' => S_DOCUMENTS,
      '承認待ち' => S_APPLIED,
      '承認済み' => S_ACTIVE,
      '却下' => S_REJECTED,
      '仮承認' => S_TEMP_ACTIVE
    }
  end

  def self.count_messages_on supporter
    joins("left outer join (#{message_count_with(supporter).to_sql}) as A on A.id = companies.id")
      .where(id: supported_by(supporter).select(:id))
      .select("companies.*, IFNULL(A.message_count, 0) AS message_count")
  end

  def toggle(type)
    update(chat_toggle: type == 'hide' ? 0 : 1)
  end

  def students
    User.select(:email).includes(:orders => :product)
        .where(products: {project_id: Project.where(company_id: self.id).pluck(:id)})
        .references(:product)
        .distinct
  end

  def can_see_ir?(user_id)
    last_order(user_id) != nil
  end

  def last_order(user_id)
    NormalOrder.where(user_id: user_id, status: NormalOrder::S_COMPLETE, project_id: Project.where(company_id: id).pluck(:id))
        .order(created_at: :desc)
        .first
  end

  def president_name
    president_last_name + president_first_name
  end

  def president_name_kana
    president_last_name_kana + president_first_name_kana
  end

  def address
    prefecture.present? ? prefecture.name + city + address1 + address2 : ''
  end

  def president_age
    date_format = '%Y%m%d'
    (Date.today.strftime(date_format).to_i - president_birth_on.strftime(date_format).to_i) / 10000
  end

  def can_publish_ir?
    Project.where(company_id: id).where.not(deliv_at: nil).size > 0
  end

  def review_url(key)
    review = reviews.where(review_type: CompanyReview.names_with_review_type[key]).first
    review.nil? ? nil : review.file.url
  end

  def review_url_with_a_tag(key)
    review = reviews.where(review_type: CompanyReview.names_with_review_type[key]).first
    review.nil? ? nil : '<a href="' + review.file.url + '">表示</a>'
  end

  def assign_issuer_id
    company = self.class.all.order(issuer_id: :desc).first
    self.issuer_id = company.issuer_id.nil? ? 1 : company.issuer_id + 1
  end

  def save_status_history
    CompanyStatusHistory.create!(
      company_id: id,
      status: status,
      is_identification_passed: is_identification_passed,
      is_antisocial_check_passed: is_antisocial_check_passed,
      reject_reason: reject_reason
    )
  end

  def can_follow?(user)
    if user.has_role?(:student) && user.student.present? && user.student.status == Student::S_REJECTED && user.student.enable_reapply == false
      false
    else
      true
    end
  end

  def followed_by?(user)
    Company::Follower.exists?(company_id: id, user_id: user.id)
  end

  def find_or_create_group_chat(category)
    group_chat = category.group_chats.with_member(self).first

    unless group_chat
      GroupChat.transaction do
        group_chat = category.group_chats.create
        group_chat.members.create(member: self)
        consultations_with_category = consultations.by_category(category)
        if consultations_with_category.any?
          consultations_with_category.each do |consultation|
            group_chat.members.create(member: consultation.supporter)
          end
        end
      end
    end

    group_chat
  end

  def as_json(options = {})
    super(options).try do |json|
      return json if options[:without_avatar]
      json.merge(
          avatar: ApplicationController.helpers.profile_image_url(user.profile),
          name: president_name,
          office: name,
          type: self.class.name
        ).transform_keys! { |k| k.to_s.camelize(:lower) }
    end
  end
end
