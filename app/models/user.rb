# coding: utf-8
class User < ActiveRecord::Base
  PERMITTED_PARAMS = [%i(email role_ids password password_confirmation),
    staff_attributes: %i(user_id company_id first_name first_name_kana last_name last_name_kana)]

  devise :database_authenticatable, :registerable, :lockable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  rolify

  attr_accessor :terms

  has_many :user_tokens, dependent: :destroy
  has_one :profile, -> { with_deleted }, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :profile, allow_destroy: true
  delegate :name, to: :profile

  has_many :user_connections, dependent: :destroy
  has_many :orders, class_name: 'NormalOrder'
  has_many :wait_orders, class_name: 'WaitOrder'
  has_one :student, dependent: :destroy
  has_one :student_agreement, dependent: :destroy
  has_one :company, dependent: :destroy
  has_one :company_agreement, dependent: :destroy
  accepts_nested_attributes_for :company, allow_destroy: true
  has_one :account, dependent: :destroy
  has_one :quit
  has_many :messages, class_name: 'Ahoy::Message'

  validates :terms, acceptance: true
  validates :roles, presence: true
  validates :email, length: {maximum: 255}

  delegate :total_investment_price, to: :student
  delegate :total_assets, to: :student

  acts_as_paranoid
  acts_as_messageable
  acts_as_voter

  ransacker :id_string do
    Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
  end

  after_create_commit do
    # check_student_ip

    #if has_role?(:student) && !Rails.env.test?
    #  job = RemindApplyUserJob.set(wait_until: created_at.since(1.day)).perform_later(id)
    #  update_column(:remind_apply_job_id, job.provider_job_id)
    #end

    #if has_role?(:student) && !Rails.env.test? && SendGridClient.has_environment?
    #  SyncSendGridUserStudentJob.perform_later(id)
    #end
  end

  after_update_commit do
    # check_student_ip
  end

  before_destroy do
  end
  after_restore :restore_profile

  def self.ransackable_attributes(auth_object = nil)
    column_names + _ransackers.keys + %w(id_string)
  end

  def self.users_with_execution(start_on, end_on)
    User.includes(:orders).where('orders.execution_at >= ? and orders.execution_at < ?', start_on, end_on).references(:orders)
  end

  def self.to_csv(users)
    CSV.generate do |csv|
      csv << %w(ユーザーID ユーザー種別 学生ID 学生状況 企業ID 企業状況 メルマガあり メールアドレス 登録日)
      users.each do |u|
        csv << [
          u.id,
          u.roles.pluck(:id).map { |id| Role.names.key(id) }.join(' '),
          u.student.present? ? u.student.id : '',
          u.student.present? ? Student.names_with_status.key(u.student.status) : '',
          u.company.present? ? u.company.id : '',
          u.company.present? ? Company.names_with_status.key(u.company.status) : '',
          u.profile.receive_notification ? '有' : '無',
          u.email,
          ApplicationController.helpers.l(u.created_at, format: :short)
        ]
      end
    end
  end

  def send_on_create_confirmation_instructions
    generate_confirmation_token! unless @raw_confirmation_token
    send_devise_notification(:confirmation_on_create_instructions, @raw_confirmation_token, {})
  end

  def set_reset_password_token
    super
  end

  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    #return "define_email@on_your.model"
    #if false
    email
  end

  def has_connection?(provider)
    connections = user_connections.select { |c| c.provider_id == provider.to_s }
                      .size
    connections > 0
  end

  def connection(provider)
    user_connections.select { |c| c.provider_id == provider.to_s }
        .first
  end

  def social_name(provider)
    user_connections.select { |c| c.provider_id == provider }
        .first
        .display_name
  end

  def can_invest?
    has_role?(:student) &&
      student.present? &&
      student.status == Student::S_ACTIVATED &&
      !student.over_aged? &&
      student.locked_at.blank? &&
      !student.need_reconfirm? &&
      student.change_notifications.where(status: [Student::ChangeNotification::S_LOCKED, Student::ChangeNotification::S_WAITING_CONFIRMATION]).empty?
  end

  def can_create_project?
    has_role?(:company) && company.present? && Project.where(company_id: company.id).size == 0
  end

  def can_delete?
    (company.blank? || (company.present? && company.project.blank?)) && orders.empty?
  end

  def use_social?
    if has_role?(:student) && student.present? && student.status != Student::S_ACTIVATED
      false
    else
      profile.use_social
    end
  end

  #def check_student_ip
  #  CheckStudentIpJob.perform_later(id) if Rails.env.production?
  #end

  def last_name
    if student.present?
      student.last_name
    elsif company.present?
      company.president_last_name
    elsif profile.present? && profile.name != '名無し'
      profile.name
    else
      email
    end
  end

  def student
    Student.unscoped { super }
  end

  def unread_notifications
    CompanySupporter::Message.unread_notifications(member_id, member_type)
  end

  def messages
    CompanySupporter::Message.messages(member_id, member_type)
  end

  def group_chat_members
    member = self.company || self.supporter || self.staff
    group_chat_members = case member
                        when Company
                          member.members
                        else
                          member.group_chat_members
                        end
  end

  def can_receive_notification?
    (self.has_role?(:company) && self.company&.chat_on?) ||
      (self.has_role?(:supporter) && self.supporter.present?) ||
      (self.has_role?(:staff) && self.staff.present?)
  end

  def member_id
    self.company.present? ? self.company.id : self.supporter.present? ? self.supporter.id : self.staff.id
  end

  def member_type
    self.company.present? ? "Company" : self.supporter.present? ? "Supporter" : "Staff"
  end

  def as_bigquery_json
    inflow_params = inflow&.inflow_params

    as_json(only: [:id])
      .merge(
        student: has_role?(:student),
        company: has_role?(:company),
        supporter: has_role?(:supporter),
        param1: inflow_params != nil && inflow_params.size > 0 ? inflow_params[0].value : nil,
        param2: inflow_params != nil && inflow_params.size > 1 ? inflow_params[1].value : nil,
        param3: inflow_params != nil && inflow_params.size > 2 ? inflow_params[2].value : nil,
        param4: inflow_params != nil && inflow_params.size > 3 ? inflow_params[3].value : nil,
        param5: inflow_params != nil && inflow_params.size > 4 ? inflow_params[4].value : nil,
        referer: inflow&.referer,
        created_at: created_at.strftime('%Y-%m-%d %H:%M:%S')
      )
      .reject { |k, v| v.nil? }
  end

  private

  def restore_profile
    profile.restore
  end
end
