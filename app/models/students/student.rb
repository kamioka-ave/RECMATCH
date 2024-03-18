# coding: utf-8
class Student < ActiveRecord::Base
  include Student::Ransackable
  extend ActiveHash::Associations::ActiveRecordExtensions

  TPRS_NOT_SUBMITTED = 0
  TPRS_SUBMITTED = 1
  TPRS_APPROVED = 2
  TPRS_REJECTED = 3

  S_NEW = 0
  S_IN_REVIEW = 1
  S_REJECTED = 2
  S_APPROVED = 3
  S_WAITING_ACTIVATION = 4
  S_ACTIVATED = 5

  G_MALE = 0
  G_FEMALE = 1

  I_OTHERS = 18
  O_OTHERS = 15

  IMT_FLUG_OFF = 0
  IMT_FLUG_ON = 1

  attr_accessor :comment, :activation_code_input, :reapply_confirmation
  alias :super_as_json :as_json

  belongs_to :user
  belongs_to :prefecture
  belongs_to :identifier, class_name: 'Admin', foreign_key: 'identifier_id'
  belongs_to :approver, class_name: 'Admin', foreign_key: 'approver_id'
  has_one :profile, through: :user
  has_many :reports, dependent: :destroy
  has_many :projects, through: :orders
  has_many :student_ability, class_name: 'StudentAbility', dependent: :destroy
  delegate :name, to: :profile
  has_one :agreement, class_name: 'StudentAgreement', foreign_key: 'student_id', dependent: :destroy
  has_many :histories, class_name: 'StudentHistory', dependent: :destroy
  has_many :status_histories, class_name: 'StudentStatusHistory', dependent: :destroy
  has_many :change_notifications, class_name: 'Student::ChangeNotification'
  has_many :project_applicants, class_name: 'Project::Applicant', dependent: :destroy
  has_many :project_meets, class_name: 'ProjectMeet', dependent: :destroy
  has_many :offers, class_name: 'Offer', dependent: :destroy

  mount_uploader :tax_payment_receipt, FileUploader
  acts_as_paranoid
  acts_as_followable
  acts_as_follower

  with_options on: :registration do |r|
    r.validates :last_name, presence: true
    r.validates :first_name, presence: true
    r.validates :last_name_kana, format: { with: /\A(?:\p{Katakana})+\z/, message: 'はカタカナで入力して下さい' }
    r.validates :first_name_kana, format: { with: /\A(?:\p{Katakana})+\z/, message: 'はカタカナで入力して下さい' }
    r.validates :nickname, presence: true
    r.validates :gender, presence: true
    r.validates :birth_on, presence: true
    r.validates :zip_code, format: { with: /\A\d{3}\-\d{4}\z/, message: '郵便番号の形式で入力して下さい' }
    r.validates :prefecture_id, presence: true
    r.validates :city, presence: true
    r.validates :address1, presence: true
    r.validates :phone, presence: { message: 'どちらか入力してください' }, if: -> { phone_mobile.blank? }
    r.validates :phone_mobile, presence: { message: 'どちらか入力してください' }, if: -> { phone.blank? }
    r.validates :phone, phone_number: true, allow_blank: true
    r.validates :phone_mobile, phone_number: true, allow_blank: true
    r.validates :university, presence: true
    r.validates :university_name, presence: { message: '大学名を入力してください' }, if: -> { university == 791 }
    r.validates :bunri, inclusion: {in: [true, false]}
    r.validates :depart, presence: true
    #r.validates :depart_detail, presence: true
    r.validates :graduation_year, presence: true
    r.validates :graduation_month, presence: true
    r.validates :industry_1, presence: true
    r.validates :occupation_1, presence: true
    r.validates :toeic_score, presence: true
    r.validates :labo, presence: true
    r.validates :circle, presence: true
    r.validates :jobhuntingaxis, presence: true
    r.validates :jobhuntingaxis_text, presence: { message: '就活軸を入力してください' }, if: -> { jobhuntingaxis == 15 }
  end

  with_options on: :lock do |l|
    l.validates :lock_reason, presence: true
  end

  before_save :remove_name_blank

  after_save do
    if saved_change_to_status? || saved_change_to_is_identification_passed? || saved_change_to_is_antisocial_check_passed?
      unless saved_change_to_status? && status == S_REJECTED && status_was != S_REJECTED
        save_status_history
      end
    end
  end

  #after_create_commit do
  #  if user.remind_apply_job_id != nil
  #    RemindApplyUserJob.cancel_by(provider_job_id: user.remind_apply_job_id)
  #    user.update_column(:remind_apply_job_id, nil)
  #  end
  #
  #  unless Rails.env.test?
  #    job = RemindApplyStudentJob.set(wait_until: created_at.since(1.day)).perform_later(id)
  #    update_column(:remind_apply_job_id, job.provider_job_id)
  #
  #    if SendGridClient.has_environment?
  #      SyncSendGridStudentJob.perform_later(id)
  #    end
  #  end
  #end

  after_update_commit do
  end

  def self.names_with_gender
    {
      男性: G_MALE,
      女性: G_FEMALE
    }
  end

  def self.names_with_gender_en
    {
      Male: G_MALE,
      Female: G_FEMALE
    }
  end

  def self.names_with_industry
    {
      '商社・卸売'.to_sym => 1,
      'コンサルティング'.to_sym => 2,
      'IT・通信'.to_sym => 3,
      '金融'.to_sym => 4,
      'メーカー'.to_sym => 5,
      '広告'.to_sym => 6,
      'マスコミ'.to_sym => 7,
      '教育'.to_sym => 8,
      '人材'.to_sym => 9,
      'エンタメ'.to_sym => 10,
      '医療・福祉'.to_sym => 11,
      '不動産・建築'.to_sym => 12,
      '小売'.to_sym => 13,
      '飲食'.to_sym => 14,
      '航空・物流・輸送・海運'.to_sym => 15,
      'インフラ'.to_sym => 16,
      '官公庁・政府系'.to_sym => 17,
      'その他'.to_sym => I_OTHERS
    }
  end

  def self.names_with_occupation
    {
      '事務管理'.to_sym => 1,
      '企画・マーケティング・経営'.to_sym => 2,
      '営業'.to_sym => 3,
      'サービス・販売・外食'.to_sym => 4,
      'WEB・インターネット・ゲーム'.to_sym => 5,
      'クリエイティブ(メディア・アパレル・デザイン)'.to_sym => 6,
      '専門職(コンサルタント・士業・金融・不動産)'.to_sym => 7,
      'ITエンジニア(システム開発・SE・インフラ)'.to_sym => 8,
      'エンジニア(機械・電気・半導体・制御)'.to_sym => 9,
      '素材・化学・食品・医薬品技術職'.to_sym => 10,
      '医療・福祉・介護'.to_sym => 11,
      '建築・土木技術職'.to_sym => 12,
      '技能工・設備・交通・運輸'.to_sym => 13,
      '教育・保育・公務員・農林水産'.to_sym => 14,
      'その他'.to_sym => O_OTHERS
    }
  end

  def self.names_with_jobhuntingaxis
    {
      'ワークライフバランスが良い'.to_sym => 1,
      '成長スピードが早い'.to_sym => 2,
      '様々な仕事ができる'.to_sym => 3,
      'ネームバリューがある'.to_sym => 4,
      '伸びしろのある企業（業界）'.to_sym => 5,
      '年収が高い'.to_sym => 6,
      '海外で働くことができる'.to_sym => 7,
      '仕事の影響が大きい'.to_sym => 8,
      '社会貢献性が高い'.to_sym => 9,
      '起業に向いている'.to_sym => 10,
      '裁量権がある'.to_sym => 11,
      '最先端の事業である'.to_sym => 12,
      '無形商材を扱う'.to_sym => 13,
      '仕事の成果が形として残る'.to_sym => 14,
      'その他'.to_sym => 15
    }
  end

  def self.names_with_tax_payment_receipt_status
    {
      未提出: TPRS_NOT_SUBMITTED,
      提出済: TPRS_SUBMITTED,
      確認済: TPRS_APPROVED,
      再提出が必要: TPRS_REJECTED
    }
  end

  def self.names_with_bank_account_type
    {
      普通: 0,
      当座: 1,
      貯蓄: 2
    }
  end

  def self.names_with_status
    {
      登録手続き中: S_NEW,
      承認待ち: S_IN_REVIEW,
      却下: S_REJECTED,
      アクティベートコード発送待ち: S_APPROVED,
      アクティベートコード入力待ち: S_WAITING_ACTIVATION,
      アクティベート済み: S_ACTIVATED
    }
  end

  def self.names_with_is_mail_target
    {
      OFF: IMT_FLUG_OFF,
      ON: IMT_FLUG_ON
    }
  end

  def self.names_with_enable_reapply
    {
      不可: 0,
      可: 1
    }
  end

  def self.to_csv(students)
    CSV.generate do |csv|
      csv << %w(
        ユーザーID 学生ID 氏名 カナ 住所 職業 業種 メールアドレス メール配信の有無 状況 投資資金の性格 主な収入 年収 金融資産 投資の目的 興味のある分野
        生年月日 勤務先 申込日（ユーザー登録申請日） 却下日 登録手続き開始日 承認待ち開始日 アクティベート発送待ち開始日 アクティベート入力待ち開始日 アクティベート完了日
      )
      students.each do |i|
        csv << [
          i.user.id,
          i.id,
          i.full_name,
          i.full_name_kana,
          i.full_address,
          Student.names_with_job.key(i.job),
          Student.names_with_business.key(i.business),
          i.user.email,
          i.user.profile.receive_notification ? '有' : '無',
          i.status_with_days,
          i.interview.present? ? StudentInterview.names_with_capital_character.key(i.interview.capital_character) : '',
          i.interview.present? ? StudentInterview.names_with_income_resource.key(i.interview.income_resource) : '',
          i.interview.present? ? StudentInterview.names_with_income.key(i.interview.income) : '',
          i.interview.present? ? StudentInterview.names_with_assets.key(i.interview.assets) : '',
          i.interview.present? ? StudentInterview.names_with_purpose.key(i.interview.purpose) : '',
          i.interview.present? ? i.interview.student_interests.pluck(:name).join(',') : '',
          ApplicationController.helpers.l(i.birth_on),
          i.company.present? ? i.company.gsub("\u2022", "\uFF0D") : '',
          ApplicationController.helpers.l(i.user.created_at, format: :short),
          (datetime = i.status_changed_at(S_REJECTED)).nil? ? '' : ApplicationController.helpers.l(datetime, format: :short),
          ApplicationController.helpers.l(i.created_at, format: :short),
          (datetime = i.status_changed_at(S_IN_REVIEW)).nil? ? '' : ApplicationController.helpers.l(datetime, format: :short),
          (datetime = i.status_changed_at(S_APPROVED)).nil? ? '' : ApplicationController.helpers.l(datetime, format: :short),
          (datetime = i.status_changed_at(S_WAITING_ACTIVATION)).nil? ? '' : ApplicationController.helpers.l(datetime, format: :short),
          (datetime = i.status_changed_at(S_ACTIVATED)).nil? ? '' : ApplicationController.helpers.l(datetime, format: :short)
        ]
      end
    end
  end

  def full_name
    "#{last_name}#{first_name}"
  end

  def full_name_kana
    "#{last_name_kana}#{first_name_kana}"
  end

  def full_address
    "#{prefecture.name}#{city}#{address1} #{address2}"
  end

  def remove_name_blank
    last_name.tr!(" 　\n\t", '')
    first_name.tr!(" 　\n\t", '')
  end

  def apply!
    if status == S_REJECTED
      if !reapply_confirmation
        errors.add(:reapply_confirmation, 'を受諾してください')
        raise StandardError.new('')
      end

      update!(
        status: S_IN_REVIEW,
        applied_at: Time.zone.now,
        activation_code: nil,
        activated_at: nil,
        is_identification_passed: nil,
        identified_at: nil,
        identifier_id: nil,
        is_antisocial_check_passed: nil,
        antisocial_checked_at: nil,
        antisocial_checker_id: nil,
        approver_id: nil
      )
    else
      update!(
        status: S_ACTIVATED,
        applied_at: Time.zone.now
      )
    end

    if remind_apply_job_id != nil
      RemindApplyStudentJob.cancel_by(provider_job_id: remind_apply_job_id)
      update_column(:remind_apply_job_id, nil)
    end

    ##AdminMailer.student_submitted(self).deliver_now
  end

  def approve!(admin_id)
    transaction do
      update!(
        status: S_APPROVED,
        activation_code: [*2..9, *'a'..'k', *'m'..'n', *'p'..'z', *'A'..'N', *'P'..'Z'].sample(6).join, # except 0,1,l,o,O
        approved_at: Time.now,
        approver_id: admin_id
      )

      pep.update!(approver_id: admin_id)
    end
  end

  def identify!(admin_id)
    now = Time.now

    transaction do
      update!(
        is_identification_passed: true,
        identified_at: now,
        identifier_id: admin_id
      )

      pep.update!(
        received_at: now,
        receiver_id: admin_id
      )
    end
  end

  def start_waiting_activation!
    now = Time.zone.now
    update!(
      status: Student::S_WAITING_ACTIVATION,
      waiting_activation_at: now
    )
    StudentMailer.sent_activation_code(self).deliver_later
    job = RemindActivationJob.set(wait_until: now.since(6.days)).perform_later(id)
    update_column(:remind_activation_job_id, job.provider_job_id)
  end

  def revert_waiting_activation_to_approved!
    if remind_activation_job_id != nil
      RemindActivationJob.cancel_by(provider_job_id: remind_activation_job_id)
    end

    update!(
      waiting_activation_at: nil,
      remind_activation_job_id: nil,
      status: Student::S_APPROVED
    )
  end

  def activate!
    if Time.now < (approved_at + 91.days)
      if activation_code == @activation_code_input
        if remind_activation_job_id != nil
          RemindActivationJob.cancel_by(provider_job_id: remind_activation_job_id)
        end

        update!(
          activated_at: Time.zone.now,
          remind_activation_job_id: nil,
          status: S_ACTIVATED
        )
      else
        errors.add(:activation_code_input, 'アクティベーションコードが異なります')
        false
      end
    else
      errors.add(:activation_code_input, '有効期限が切れています')
      false
    end
  end

  def reject!
    transaction do
      if remind_activation_job_id != nil
        RemindActivationJob.cancel_by(provider_job_id: remind_activation_job_id)
      end

      update!(
        status: S_REJECTED,
        rejected_at: Time.zone.now,
        remind_activation_job_id: nil
      )
      StudentMailer.rejected(self).deliver_later
    end
  end

  def reject_without_mail!
    transaction do
      if remind_activation_job_id != nil
        RemindActivationJob.cancel_by(provider_job_id: remind_activation_job_id)
      end

      update!(
        status: S_REJECTED,
        rejected_at: Time.zone.now,
        remind_activation_job_id: nil
      )
      save_status_history
    end
  end

  def reject_with_reconfirm!
    transaction do
      if remind_activation_job_id != nil
        RemindActivationJob.cancel_by(provider_job_id: remind_activation_job_id)
      end

      update!(
        status: S_REJECTED,
        rejected_at: Time.zone.now,
        locked_at: nil,
        lock_reason: nil,
        remind_activation_job_id: nil
      )
      StudentMailer.reconfirm_rejected(self).deliver_later
    end
  end

  def reject_with_antisocial!(admin_id)
    transaction do
      update!(
        is_antisocial_check_passed: false,
        antisocial_checked_at: Time.now,
        antisocial_checker_id: admin_id,
        status: S_REJECTED
      )
      StudentMailer.rejected(self).deliver_later
    end
  end

  def reject_with_identification!(admin_id)
    transaction do
      update!(
        is_identification_passed: false,
        identified_at: Time.now,
        identifier_id: admin_id,
        status: S_REJECTED
      )
      StudentMailer.rejected(self).deliver_later
    end
  end

  def save_status_history(mail_subject = nil, mail_body = nil)
    history = StudentStatusHistory.new(
      student_id: id,
      status: status,
      mail_subject: mail_subject,
      mail_body: mail_body
    )

    history.is_identification_passed = is_identification_passed unless is_identification_passed.nil?
    history.is_antisocial_check_passed = is_antisocial_check_passed unless is_antisocial_check_passed.nil?

    history.save!
  end

  def age
    date_format = '%Y%m%d'
    (Date.today.strftime(date_format).to_i - birth_on.strftime(date_format).to_i) / 10_000
  end

  def age_must_o20_and_u80
    if age < 20 || age >= 80
      errors.add(:birth_on, '')
    end
  end

  def over_aged?
    age >= 80
  end

  def not_suitable?
    interview.not_suitable?
  end

  def suitable?
    !interview.not_suitable?
  end

  def antisocialist?
    Antisocialist.find_with_name(last_name, first_name, age)
  end

  # 以前非承認となったが再申請か？
  def reapplication?
    Student.where('id < ?', id).where(first_name: first_name, last_name: last_name, birth_on: birth_on).first
  end

  def need_reconfirm?
    # if Rails.env.production?
    #   status == Student::S_ACTIVATED && (applied_at.blank? || applied_at < Time.new(2017, 4, 23, 10, 0, 0, '+09:00')) && reconfirm_applied_at == nil
    # else
    #   status == Student::S_ACTIVATED && (applied_at.blank? || applied_at < Date.new(2017, 4, 4)) && reconfirm_applied_at == nil
    # end
    false
  end

  def can_sign_in?
    if status == Student::S_REJECTED
      if !enable_reapply || (rejected_at.present? && rejected_at > 6.months.ago)
        return false
      end
    end

    true
  end

  def as_json(options = {})
    super(options).merge(
      full_name: full_name,
      full_name_kana: full_name_kana,
      full_address: full_address,
      gender: Student.names_with_gender.key(gender),
      birth_on: ApplicationController.helpers.l(birth_on),
      prefecture: prefecture.name,
      job: Student.names_with_job.key(job),
      business: Student.names_with_business.key(business),
      bank: bank.name_with_bank,
      bank_branch: bank_branch.present? ? bank_branch.name_with_branch : nil,
      bank_account_type: Student.names_with_bank_account_type.key(bank_account_type),
      updated_at: ApplicationController.helpers.l(updated_at)
    )
  end

  def histories_for_card
    card_histories = []
    prev = StudentHistory.new_with_student(self)

    histories.where('updated_at > ?', approved_at).order(updated_at: :desc).each do |h|
      changes_with_prev = h.changes_with_prev(prev)

      unless changes_with_prev.empty?
        card_histories << StudentCardHistory.new(prev.updated_at, changes_with_prev.join(', '))
        prev = h
      end
    end

    interview.histories_for_card.each do |h|
      card_histories << h
    end

    card_histories.sort { |a, b| b.updated_at <=> a.updated_at }
  end

  def can_check_classified?(project)
    if need_reconfirm?
      false
    else
      if locked_at.present?
        status == Student::S_ACTIVATED && User.includes(orders: :product).where(id: self.user_id, products: {project_id: project.id}).references(:product).size > 0
      else
        status == Student::S_ACTIVATED
      end
    end
  end

  def same_phones
    if phone.present?
      Student.where.not(id: id).where(phone: phone)
    else
      []
    end
  end

  def same_mobile_phones
    if phone_mobile.present?
      Student.where.not(id: id).where(phone_mobile: phone_mobile)
    else
      []
    end
  end

  def status_with_days
    r = Student.names_with_status.key(status).to_s

    case status
    when S_NEW
      r += "（#{(Date.today - created_at.to_date).to_i}日経過）"
    when S_IN_REVIEW
      if !not_suitable? && applied_at.present?
        r += "（#{(Date.today - applied_at.to_date).to_i}日経過）"
      end
    when S_WAITING_ACTIVATION
      r += "（#{(Date.today - updated_at.to_date).to_i}日経過）"
    end

    r
  end

  def invested_projects
    NormalOrder.includes(:project).where(user_id: user_id)
      .where.not(status: [NormalOrder::S_CANCEL, NormalOrder::S_LOST])
      .group(:project_id)
      .pluck('projects.name')
      .join(',')
  end

  def total_assets
    StockHistory.latest_per_company
      .joins("RIGHT OUTER JOIN (#{stock_per_complete_order.to_sql}) AS t2 ON t1.cid = t2.cid")
      .pluck(Arel.sql('SUM(IFNULL(stock * price * partition_number, order_price))'))
      .first || 0
  end

  def assets_per_category
    StockHistory.latest_per_company
      .joins("RIGHT OUTER JOIN (#{stock_per_complete_order.to_sql}) AS t2 ON t1.cid = t2.cid")
      .joins('INNER JOIN project_categories ON t2.pid = project_categories.project_id')
      .joins('INNER JOIN categories ON categories.id = project_categories.category_id')
      .group('project_categories.project_id, categories.name')
      .select('categories.name, SUM(IFNULL(stock * price * partition_number, order_price)) AS assets')
      .as_json
  end

  def refresh_total_order!
    price = 0
    orders = NormalOrder.where(student_id: id)
               .where.not(status: [NormalOrder::S_CANCEL, NormalOrder::S_LOST])

    if total_order_count != orders.count
      update_column(:total_order_count, orders.count)
    end

    orders.each do |o|
      price += (o.price - o.lost_orders.reduce(0) { |sum, l| sum + l.price })
    end

    if total_order_price != price
      update_column(:total_order_price, price)
    end

    price = 0
    orders = NormalOrder.where(student_id: id, status: NormalOrder::S_COMPLETE)
    orders.each do |o|
      price += (o.price - o.lost_orders.reduce(0) { |sum, l| sum + l.price })
    end

    if total_investment_price != price
      update_column(:total_investment_price, price)
    end
  end

  def status_with_days_passed
    if status_histories.size > 0
      (Time.now.to_i - status_histories.first.created_at.to_i) / 86400  # 60*60*24
    else
      nil
    end
  end

  def need_lock_and_notify?
    first_name_changed? || first_name_kana_changed? || last_name_changed? || last_name_kana_changed? ||
      gender_changed? || birth_on_changed? || zip_code_changed? || prefecture_id_changed? || city_changed? ||
      address1_changed? || address2_changed? || bank_id_changed? || bank_branch_id_changed? || bank_account_type_changed? ||
      bank_account_number_changed? || bank_account_name_changed?
  end

  def time_by_status(status)
    history = StudentStatusHistory.unscoped.where(student_id: id, status: status).order(:created_at).first
    history.nil? ? nil : history.created_at.iso8601
  end

  def stocks_with_project(project_id)
    stocks = 0
    NormalOrder.where(user_id: user_id, project_id: project_id, status: NormalOrder::S_COMPLETE).each do |o|
      stocks += (o.amount - o.lost_orders.reduce(0) { |sum, o| sum + o.amount })
    end
    stocks
  end

  def build_pdf
    WickedPdf.new.pdf_from_string(
      ApplicationController.render(
        template: 'admin/students/card',
        orientation: 'Portrait',
        page_size: 'A4',
        encoding: 'UTF-8',
        assigns: {
          student: self
        }
      )
    )
  end

  def build_ledger_pdf
    WickedPdf.new.pdf_from_string(
      ApplicationController.render(
        template: 'admin/students/ledger',
        orientation: 'Portrait',
        page_size: 'A4',
        encoding: 'UTF-8',
        assigns: {
          student: self
        }
      )
    )
  end

  def status_changed_at(status)
    h = status_histories.where(status: status).order(created_at: :desc).first
    h.present? ? h.created_at : nil
  end

  def need_identification?
    will_save_change_to_first_name? |
      will_save_change_to_first_name_kana? ||
      will_save_change_to_last_name? ||
      will_save_change_to_last_name_kana? ||
      will_save_change_to_zip_code? ||
      will_save_change_to_prefecture_id? ||
      will_save_change_to_city? ||
      will_save_change_to_address1? ||
      will_save_change_to_address2?
  end

  def need_change_notification?
    need_identification? ||
    will_save_change_to_bank_id? ||
      will_save_change_to_bank_branch_id? ||
      will_save_change_to_bank_account_type? ||
      will_save_change_to_bank_account_number? ||
      will_save_change_to_bank_account_name?
  end

  def build_change_notification_params
    params = {
      student_id: id,
      gender: gender,
      birth_on: birth_on,
      phone: phone,
      phone_mobile: phone_mobile,
      job: job,
      job_details: job_details,
      company: company,
      phone_company: phone_company,
      email_company: email_company
    }

    if will_save_change_to_first_name? || will_save_change_to_last_name? || will_save_change_to_first_name_kana? || will_save_change_to_last_name_kana?
      params.merge!(
        first_name: first_name,
        first_name_prev: will_save_change_to_first_name? ? first_name_in_database : first_name,
        last_name: last_name,
        last_name_prev: will_save_change_to_last_name? ? last_name_in_database : last_name,
        first_name_kana: first_name_kana,
        first_name_kana_prev: will_save_change_to_first_name_kana? ? first_name_kana_in_database : first_name_kana,
        last_name_kana: last_name_kana,
        last_name_kana_prev: will_save_change_to_last_name_kana? ? last_name_kana_in_database : last_name_kana,
        name_modified: true
      )
    end

    if will_save_change_to_zip_code? ||  will_save_change_to_prefecture_id? || will_save_change_to_city? || will_save_change_to_address1? || will_save_change_to_address2?
      params.merge!(
        zip_code: zip_code,
        zip_code_prev: will_save_change_to_zip_code? ? zip_code_in_database : zip_code,
        prefecture_id: prefecture_id,
        prefecture_id_prev: will_save_change_to_prefecture_id? ? prefecture_id_in_database : prefecture_id,
        city: city,
        city_prev: will_save_change_to_city? ? city_in_database : city,
        address1: address1,
        address1_prev: will_save_change_to_address1? ? address1_in_database : address1,
        address2: address2,
        address2_prev: will_save_change_to_address2? ? address2_in_database : address2,
        address_modified: true
      )
    end

    if will_save_change_to_bank_id? || will_save_change_to_bank_branch_id? || will_save_change_to_bank_account_type? || will_save_change_to_bank_account_number? || will_save_change_to_bank_account_name?
      params.merge!(
        bank_id: bank_id,
        bank_id_prev: will_save_change_to_bank_id? ? bank_id_in_database : bank_id,
        bank_branch_id: bank_branch_id,
        bank_branch_id_prev: will_save_change_to_bank_branch_id? ? bank_branch_id_in_database : bank_branch_id,
        bank_account_type: bank_account_type,
        bank_account_type_prev: will_save_change_to_bank_account_type? ? bank_account_type_in_database : bank_account_type,
        bank_account_number: bank_account_number,
        bank_account_number_prev: will_save_change_to_bank_account_number? ? bank_account_number_in_database : bank_account_number,
        bank_account_name: bank_account_name,
        bank_account_name_prev: will_save_change_to_bank_account_name? ? bank_account_name_in_database : bank_account_name,
        bank_modified: true
      )
    end

    params
  end

  #def update_by_user!(params)
  #  history = StudentHistory.new_with_student(self)
  #  self.attributes = params

  #  unless valid?(:registration)
  #    return false
  #  end

  #  if need_change_notification?
  #    if change_notification.nil?
  #      Student::ChangeNotification.create!(build_change_notification_params)
  #    else
  #      change_notification.update!(build_change_notification_params)
  #    end
  #  else
  #    if changed?
  #      self.revision += 1

  #      ActiveRecord::Base.transaction do
  #        history.save!
  #        save!
  #      end
  #    end
  #  end

  #  true
  #end

  def change_notification
    change_notifications.where(status: Student::ChangeNotification::S_NEW).first
  end

  def unprocessed_change_notification
    change_notifications.where(status: Student::ChangeNotification::S_NOTIFIED).first
  end

  def merge_change_notification
    self.gender = gender
    self.birth_on = birth_on
    self.phone = phone
    self.phone_mobile = phone_mobile
    self.job = job
    self.job_details = job_details
    self.company = company
    self.phone_company = phone_company
    self.email_company = email_company

    if change_notification.name_modified
      self.first_name = change_notification.first_name
      self.last_name = change_notification.last_name
      self.first_name_kana = change_notification.first_name_kana
      self.last_name_kana = change_notification.last_name_kana
    end

    if change_notification.address_modified
      self.zip_code = change_notification.zip_code
      self.prefecture_id = change_notification.prefecture_id
      self.city = change_notification.city
      self.address1 = change_notification.address1
      self.address2 = change_notification.address2
    end

    if change_notification.bank_modified
      self.bank_id = change_notification.bank_id
      self.bank_branch_id = change_notification.bank_branch_id
      self.bank_account_type = change_notification.bank_account_type
      self.bank_account_number = change_notification.bank_account_number
      self.bank_account_name = change_notification.bank_account_name
    end
  end

  # 取引残高報告書を交付
  def report_transaction_balance(start_on, end_on)
    transaction_start_on = nil
    orders = NormalOrder.where(student_id: id)
               .where('deliv_at >= ? and deliv_at < ?', start_on, end_on)
               .where.not(status: [NormalOrder::S_CANCEL, NormalOrder::S_LOST])
               .order(:execution_at)
    if orders.size > 0
      date = orders.first.execution_at.to_date
      if date < start_on
        transaction_start_on = date
      end
    end

    records = StudentTransactionRecord.where(student_id: id)
                .where('transaction_at >= ? and transaction_at < ?', transaction_start_on || start_on, end_on)
                .order(:transaction_at)
    if records.size > 0
      transaction do
        report = TransactionBalanceReport.create!(
          user_id: user_id,
          name: '取引残高報告書',
          student_name: full_name,
          balance: user.account.balance,
          start_on: start_on,
          end_on: end_on,
          version: 2
        )

        records.each do |r|
          if r.transaction_type == StudentTransactionRecord::TR_EXECUTED
            ReportItem.create!(
              report_id: report.id,
              order_id: r.order_id,
              student_transaction_record_id: r.id,
              deliv_at: r.order.deliv_at,
              company_address: r.order.company.address
            )
          else
            ReportItem.create!(
              report_id: report.id,
              student_transaction_record_id: r.id
            )
          end
        end
      end

      StudentMailer.transaction_balance_reported(self).deliver_later
    else
      start_on_prev = end_on - (end_on.year == 2018 && end_on.month == 10 && end_on.day == 1 ? 18.months : 15.months) # 2018.10.01はイレギュラー対応
      three_months_records = StudentTransactionRecord.where(student_id: id)
                  .where('transaction_at >= ? and transaction_at < ?', start_on_prev, end_on - 12.months)
      last_year_records = StudentTransactionRecord.where(student_id: id)
                            .where('transaction_at >= ? and transaction_at < ?', end_on - 12.months, end_on)
      if !three_months_records.empty? && last_year_records.empty?
        TransactionBalanceReport.create!(
          user_id: user_id,
          name: '取引残高報告書',
          student_name: full_name,
          balance: user.account.balance,
          start_on: start_on,
          end_on: end_on,
          version: 2
        )
        StudentMailer.transaction_balance_reported(self).deliver_later
      end
    end
  end

  def calculate_assets(company_ids: nil)
    accumulated_orders = NormalOrder.accumulate_stock_on(student: self, company_ids: company_ids)
    company_ids ||= accumulated_orders.map(&:company_id)
    stock_histories = StockHistory.where(company_id: company_ids).order(date: :asc).all
    StudentAsset.new stock_histories, accumulated_orders, company_ids
  end

  def stock_per_complete_order
    selectors = <<~SQL
      (orders.amount - IFNULL(SUM(lost_orders_orders.amount), 0)) AS stock,
      (orders.price - IFNULL(SUM(lost_orders_orders.price), 0)) AS order_price,
      companies.id AS cid,
      orders.id AS oid,
      orders.project_id AS pid
    SQL
    Company
      .left_outer_joins(orders: [:lost_orders])
      .where(orders: {student_id: id, status: NormalOrder::S_COMPLETE},
        lost_orders_orders: {status: [LostOrder::S_PART, nil]})
      .group('companies.id, orders.id, orders.project_id')
      .select(selectors)
  end

  def profit_rate
    return 0 if total_investment_price.zero?
    ((total_assets - total_investment_price.to_f) / total_investment_price * 100).round
  end

  def as_bigquery_json
    last_event = Ahoy::Event.where(user_id: user.id)
                   .where.not(name: '$change')
                   .order(time: :desc)
                   .first
    inflow = user&.inflow
    inflow_params = inflow&.inflow_params

    super_as_json(only: [:id, :user_id])
      .merge(
        status: Student.names_with_status.key(status),
        applied_at: applied_at&.strftime('%Y-%m-%d %H:%M:%S'),
        activated_at: activated_at&.strftime('%Y-%m-%d %H:%M:%S'),
        last_accessed_at: last_event&.time&.strftime('%Y-%m-%d %H:%M:%S'),
        order_count: total_order_count,
        invested: total_order_price,
        param1: inflow_params != nil && inflow_params.size > 0 ? inflow_params[0].value : nil,
        param2: inflow_params != nil && inflow_params.size > 1 ? inflow_params[1].value : nil,
        param3: inflow_params != nil && inflow_params.size > 2 ? inflow_params[2].value : nil,
        param4: inflow_params != nil && inflow_params.size > 3 ? inflow_params[3].value : nil,
        param5: inflow_params != nil && inflow_params.size > 4 ? inflow_params[4].value : nil,
        referer: inflow&.referer,
        income_resource: interview.present? ? StudentInterview.names_with_income_resource.key(interview.income_resource) : nil,
        income: interview.present? ? StudentInterview.names_with_income.key(interview.income) : nil,
        assets: interview.present? ? StudentInterview.names_with_assets.key(interview.assets) : nil,
        capital_character: interview.present? ? StudentInterview.names_with_capital_character.key(interview.capital_character) : nil,
        purpose: interview.present? ? StudentInterview.names_with_purpose.key(interview.purpose) : nil,
        has_experience: interview.present? ? (interview.has_experience ? '有' : '無') : nil,
        exp_stock: interview&.exp_stock,
        exp_bond: interview&.exp_bond,
        exp_trust_fund: interview&.exp_trust_fund,
        exp_commodity_futures: interview&.exp_commodity_futures,
        exp_foreign_currency_saving: interview&.exp_foreign_currency_saving,
        exp_foreign_exchange: interview&.exp_foreign_exchange,
        exp_account: interview&.exp_account,
        created_at: created_at.strftime('%Y-%m-%d %H:%M:%S')
      )
      .reject { |_, v| v.nil? }
  end
end
