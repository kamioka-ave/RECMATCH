class Project < ApplicationRecord
  include Sanitizable
  #include Projectable
  #include Project::Shareholders

  S_NEW = 0
  S_EDIT = 1
  S_JUDGE = 2
  S_BACK = 3
  S_ACTIVE = 4
  S_REJECTED = 5
  S_FINISH = 6

  attr_reader :admin, :authorizer
  #attr_accessor :start, :end

  belongs_to :company
  has_one :user, through: :company
  has_one :profile, through: :user
  has_many :project_categories, dependent: :destroy
  has_many :categories, through: :project_categories
  accepts_nested_attributes_for :project_categories
  has_many :orders, class_name: 'NormalOrder'
  has_many :wait_orders, class_name: 'WaitOrder'
  has_many :lost_orders, class_name: 'LostOrder'
  belongs_to :project_draft, dependent: :destroy
  has_many :project_invoices, dependent: :destroy
  has_many :headlines, class_name: 'ProjectHeadline', dependent: :destroy
  has_many :company_transaction_records
  has_many :contract_images, class_name: 'Project::ContractImage', as: :projectable, dependent: :destroy
  has_many :company_presidents, class_name: 'Project::CompanyPresident', as: :projectable, dependent: :destroy
  has_many :case_studies, dependent: :destroy
  has_many :terms, class_name: 'Project::Term', dependent: :destroy
  has_many :applicants, class_name: 'Project::Applicant', dependent: :destroy
  has_many :project_meets, class_name: 'ProjectMeet', dependent: :destroy
  has_many :project_corrected_documents, dependent: :destroy

  mount_uploader :image, ProjectUploader
  mount_uploader :president_image, ProfileUploader
  mount_uploader :stamp, ImageUploader
  mount_uploader :contract_attachment, FileUploader

  scope :in_process, -> { where(status: Project::S_ACTIVE) } # 進行中
  scope :succeeded, -> { where('status >= ?', Project::S_REJECTED) } # 募集成立済み

  after_create_commit do
    job = ProjectFinishJob.set(wait_until: entry_closed.end_of_day).perform_later(id)
    update_column(:finish_job_id , job.provider_job_id)
  end

  after_update_commit do
    if finish_job_id.present?
      ProjectFinishJob.cancel_by(provider_job_id: finish_job_id)
      update_column(:finish_job_id , nil)
    end
    job = ProjectFinishJob.set(wait_until: entry_closed.end_of_day).perform_later(id)
    update_column(:finish_job_id , job.provider_job_id)
  end

  acts_as_commentable

  def self.names_with_status
    {
      '申込み済み' => S_NEW,
      '公開(編集未完)' => S_EDIT,
      '審査中' => S_JUDGE,
      '修正依頼中' => S_BACK,
      '公開' => S_ACTIVE,
      '却下' => S_REJECTED,
      '終了' => S_FINISH
    }
  end

  def self.css_with_colors
    {
        0 => '#FF0000',
        1 => '#5cb85c',
        2 => '#5bc0de',
        3 => '#F2994A',
        4 => '#FF0000',
        5 => '#5cb85c',
        6 => '#5bc0de',
        7 => '#F2994A',
        8 => '#FF0000',
        9 => '#5cb85c',
        10 => '#5bc0de',
        11 => '#F2994A',
        12 => '#FF0000',
        13 => '#5cb85c',
        14 => '#5bc0de',
        15 => '#F2994A',
        16 => '#FF0000',
        17 => '#5bc0de',
        18 => '#C0C0C0'
    }
  end

  def amount
    solicited
  end

  def students
    Student.includes(:orders).where(orders: { type: 'NormalOrder', project_id: id })
      .where.not(orders: { status: [NormalOrder::S_CANCEL, NormalOrder::S_LOST] })
      .references(:orders)
  end

  def can_comment?(user)
    user.use_social? &&
      user.has_role?(:student).where(id: user.id)
  end

  # 募集成立判定
  def succeeded?
    (solicited >= solicit && finish_at <= Time.zone.now) || (solicited >= solicit_limit)
  end

  # プロジェクト募集成立時の処理
  #
  # Need transaction lock!
  def succeed!(succeeded_at = nil)
    self.status = Project::S_SUCCEEDED
    self.succeeded_at = succeeded_at != nil ? succeeded_at : Time.zone.now
    self.succeeded_price = solicited
    self.is_succeeded_with_limit = solicited >= solicit_limit
    self.execution_at = calc_execution_at
    self.payment_start_on = calc_payment_start_on(execution_at)
    self.payment_at = calc_payment_at(execution_at)
    self.lost_at = calc_lost_at(payment_at)
    self.deliv_due_at = calc_deliv_at(payment_at)
    job = ProjectExecuteJob.set(wait_until: execution_at).perform_later(id)
    self.execution_job_id = job.provider_job_id
    save!(validate: false)

    orders.not_canceled.each do |o|
      o.update!(
        execution_at: execution_at,
        payment_due_at: payment_at,
        deliv_due_at: deliv_due_at
      )

      if is_succeeded_with_limit
        StudentMailer.project_succeeded_with_limit(o).deliver_later
      else
        StudentMailer.project_succeeded(o).deliver_later
      end
    end

    if Rails.env.production?
      project_url = Rails.application.routes.url_helpers.project_url(id, host: Rails.application.config.action_mailer.default_url_options[:host])
      message = "[#{name}](#{project_url})が募集成立しました。約定は#{execution_at.strftime('%Y.%m.%d')}です。"
      SlackNotifyJob.perform_later(message)
    end
  end

  # 約定時の処理
  #
  # Need transaction lock!
  def execute!
    self.status = S_EXECUTED
    self.execution_price = solicited
    save!(validate: false)

    orders.where(status: NormalOrder::S_NEW).each do |o|
      StudentTransactionRecord.create_executed(o)

      OrderReport.create!(
        user_id: o.user_id,
        order_id: o.id,
        name: "#{o.project.name} 取引報告書",
        student_name: o.student&.full_name,
        version: 2
      )
      QuotaReport.create!(
        user_id: o.user_id,
        order_id: o.id,
        name: "#{o.project.name} 株式割当通知書",
        student_name: o.student&.full_name,
        version: 1
      )
      StudentMailer.project_executed(o).deliver_later
      StudentMailer.notify_quota(o).deliver_later
      o.update!(status: NormalOrder::S_PAY_WAIT)
    end

    wait_orders.where(status: WaitOrder::S_NEW).each(&:abort!)
    CompanyTransactionRecord.create_executed(self)
    CheckLostOrderJob.set(wait_until: lost_at).perform_later(id)

    if Rails.env.production?
      project_url = Rails.application.routes.url_helpers.project_url(id, host: Rails.application.config.action_mailer.default_url_options[:host])
      message = "[#{name}](#{project_url})が約定しました。振込期限は#{payment_at.strftime('%Y.%m.%d')}です。"
      SlackNotifyJob.perform_later(message)
    end
  end

  # 不成立にする
  #
  # Need transaction lock!
  def fail!
    self.status = S_FAILED
    self.failed_at = Time.zone.now
    save!(validate: false)

    orders.where(status: NormalOrder::S_NEW).each do |o|
      StudentMailer.project_dissolved(o).deliver_later
      o.cancel!(finish_at, false)
    end

    if Rails.env.production?
      project_url = Rails.application.routes.url_helpers.project_url(id, host: Rails.application.config.action_mailer.default_url_options[:host])
      message = "[#{name}](#{project_url})が不成立となりました。"
      SlackNotifyJob.perform_later(message)
    end
  end

  # プロジェクト中止時の処理
  def abort!
    self.status = S_ABORT
    save!(validate: false)

    orders.where(status: [NormalOrder::S_COMPLETE, NormalOrder::S_PAY_WAIT]).each do |o|
      StudentTransactionRecord.create_cancel(o, Time.zone.now)
    end

    orders.where(status: [NormalOrder::S_COMPLETE, NormalOrder::S_PAY_WAIT]).each do |o|
      StudentMailer.project_aborted(o).deliver_later
    end
  end

  # 再募集する
  #
  # Need transaction lock!
  def restart!
    self.is_succeeded_with_limit = false
    self.status = S_IN_PROGRESS
    save!(validate: false)

    orders.where(status: NormalOrder::S_NEW).each do |o|
      StudentMailer.project_restarted(o).deliver_later
    end
  end

  # 約定日時の算出
  def calc_execution_at(succeeded_at = nil)
    if succeeded_at.nil?
      succeeded_at = self.succeeded_at
    end

    if is_succeeded_with_limit && (finish_at - succeeded_at).to_i >= 86_385 # 24*60*60
      (succeeded_at + 9.days).change(hour: 0, min: 0, sec: 0)
    else
      (succeeded_at + 8.days).change(hour: 0, min: 0, sec: 0)
    end
  end

  # 支払開始日の算出
  def calc_payment_start_on(execution_at)
    payment_day = Chronic.parse('next Monday', now: execution_at)

    loop do
      if Bank.business_day?(payment_day)
        break
      end
      payment_day += 1.day
    end

    payment_day.to_date
  end

  # 最終支払日の算出
  def calc_payment_at(execution_at)
    business_days = 0
    payment_day = Chronic.parse('next Monday', now: execution_at)

    loop do
      if Bank.business_day?(payment_day)
        business_days += 1
        break if business_days >= 3
      end
      payment_day += 1.day
    end

    payment_day
  end

  # 失権日時の算出
  def calc_lost_at(payment_at)
    (payment_at + 10.days).change(hour: 23, min: 59, sec: 0)
  end

  # 受渡日時の算出
  # TODO: 金曜日が祝日だった場合を考慮する（ドキュメントがおかしいので要確認）
  def calc_deliv_at(payment_at)
    Chronic.parse('next Friday', now: payment_at)
  end

  def achievement_rate
    (solicited * 100) / solicit
  end

  def payment_limit_description
    days = (lost_at.to_date - payment_at.to_date).to_i

    if days >= 30
      '1ケ月'
    else
      "#{days}日"
    end
  end

  def cancel_count_after_succeeded
    if succeeded_at.blank?
      return 0
    end

    orders.where(status: NormalOrder::S_CANCEL)
      .where('updated_at > ?', succeeded_at)
      .size
  end

  def cancels_price_after_succeeded
    if succeeded_at.blank?
      return 0
    end

    orders.where(status: NormalOrder::S_CANCEL)
      .where('updated_at > ?', succeeded_at)
      .reduce(0) { |sum, o| sum + o.price }
  end

  def lost_count
    if lost_at.blank? || lost_at > Time.zone.now
      return 0
    end

    orders.where(status: NormalOrder::S_LOST, parent_id: nil).size +
      orders.where(parent_id: nil).reject { |o| o.lost_orders.empty? }.size
  end

  def losts_price
    if lost_at.blank? || lost_at > Time.zone.now
      0
    else
      orders.where(status: NormalOrder::S_LOST)
        .reduce(0) { |sum, o| sum + o.price }
    end
  end

  def cancels_until_limit
    if is_succeeded_with_limit
      orders.where(status: NormalOrder::S_CANCEL).where('updated_at < ?', succeeded_at).size
    end
  end

  def cancels_price_until_limit
    if is_succeeded_with_limit
      orders.where(status: NormalOrder::S_CANCEL)
        .where('updated_at < ?', succeeded_at)
        .reduce(0) { |sum, o| sum + o.price }
    end
  end

  # 申込みがキャンセルされた場合の処理
  #
  # @param [NormalOrder] 対象の申込み
  def order_canceled!(order)
    with_lock do
      self.solicited -= order.price

      wait_orders_price = wait_orders.where(parent_id: nil, status: WaitOrder::S_NEW)
                            .reduce(0) { |sum, o| sum + o.price }

      if status == Project::S_SUCCEEDED && (solicited + wait_orders_price) < solicit
        if finish_at >= Time.zone.now
          restart!
        else
          self.status = S_FAILED
          self.failed_at = Time.zone.now
          save!(validate: false)
          CancelAllOrdersWithFailure.perform_later(id, order.id)

          if Rails.env.production?
            project_url = Rails.application.routes.url_helpers.project_url(
              id,
              host: Rails.application.config.action_mailer.default_url_options[:host]
            )
            message = "[#{name}](#{project_url})がキャンセル発生により不成立となりました。"
            SlackNotifyJob.perform_later(message)
          end
        end
      else
        save!(validate: false)
      end

      if wait_orders_price > 0
        ConsumeWaitOrderJob.perform_later(id)
      end
    end
  end

  def consume_wait_order!
    wait_orders.where(parent_id: nil, status: WaitOrder::S_NEW).order(id: :asc).each do |w|
      w.with_lock do
        if w.parent_id.nil? && w.status == WaitOrder::S_NEW && solicit_limit - solicited >= w.price
          o = NormalOrder.new(
            user_id: w.user_id,
            contract_confirmed: w.contract_confirmed,
            execution_at: execution_at,
            deliv_due_at: deliv_due_at,
            payment_due_at: payment_at
          )
          o.apply!(w)
          reload
        end
      end
    end
  end

  def angel_downloads_csv
    CSV.generate do |csv|
      csv << %w(注文ID 学生ID Eメール 学生名 学生名(カナ) 株数 金額 申請済か)
      orders.where(angel_confirmed1: true, angel_confirmed2: true).each do |o|
        csv << [
          o.id,
          o.student_id,
          o.user.email,
          o.student.full_name,
          o.student.full_name_kana,
          o.amount,
          o.price,
          o.angel_applied ? '申請済' : '未申請'
        ]
      end
    end
  end

  def angel_report_title
    angel_type == Project::ANGEL_TYPE_A ? 'angel_form_A' : 'angel_form_B'
  end

  def finish_ats
    ats = terms.map(&:finish_at)
    ats.push(finish_at)

    if id < 22 && is_succeeded_with_limit
      ats.push(succeeded_at)
    end

    ats
  end

  def applicants_csv
    CSV.generate do |csv|
      csv << %w(
          学生ID Eメール 姓 名 姓(カナ) 名(カナ)
        )
      applicants.each do |a|
        csv << [
          a.student_id,
          a.student.user.email,
          a.student.last_name,
          a.student.first_name,
          a.student.last_name_kana,
          a.student.first_name_kana
        ]
      end
    end
  end

  def to_bigquery_json
    {
      id: id,
      name: name,
      created_at: created_at.strftime('%Y-%m-%d %H:%M:%S'),
      start_at: start_at.strftime('%Y-%m-%d %H:%M:%S'),
      limit_touched_at: is_succeeded_with_limit ? succeeded_at.strftime('%Y-%m-%d %H:%M:%S') : nil
    }
      .reject { |k, v| v.nil? }
      .to_json
  end

  def can_display?
    start_at > Time.zone.now ? enable_front_display : !(status == S_REJECTED)
  end
end
