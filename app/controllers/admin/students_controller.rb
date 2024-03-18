class Admin::StudentsController < Admin::AdminController
  load_and_authorize_resource
  before_action(:set_student, only: [
    :show, :edit, :update, :confirm, :approve, :reject, :card, :ledger, :identification_record, :transactions,
    :change_mail_target, :enable_reapply, :disapble_reapply
  ])

  def index
    @q = Student.order('id DESC').ransack(params[:q])
    @q.build_condition if @q.conditions.empty?
    @students = @q.result(distinct: true).page(params[:page]).per(100)
    @students_display = current_admin.students_display
    @conditions = @q.conditions.map.with_index do |c, i|
      {
        id: i,
        attribute: c.attributes.empty? ? nil : c.attributes.first.name,
        predicate: c.predicate.nil? ? nil : c.predicate.name,
        value: c.values.empty? ? nil : c.values.first.value
      }
    end
  end

  def show
    @reapplication = @student.reapplication?
    @transaction_balance_reports = TransactionBalanceReport.where(user_id: @student.user_id).order(created_at: :desc)
    @events = Event.joins(:event_applicant).where("student_id=?", @student.id)
                .where.not(status: 4)
                .order(start: :desc)
                .limit(10)
    @change_notifications = Student::ChangeNotification.where(student_id: @student.id)
                              .where.not(status: Student::ChangeNotification::S_NEW)
                              .order(notified_at: :desc)
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '学生一覧', admin_students_path
    add_breadcrumb @student.full_name
  end

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '学生一覧', admin_students_path
    add_breadcrumb @student.full_name, admin_student_path(@student)
    add_breadcrumb '学生申請内容の編集'
  end

  def update
    history = StudentHistory.new_with_student(@student)
    @student.attributes = student_params

    if @student.valid?
      if @student.changed?
        @student.revision += 1
        ActiveRecord::Base.transaction do
          history.save!
          @student.save!
        end
      end
      redirect_to admin_student_path(@student), notice: '学生申請内容を編集しました'
    else
      render :edit
    end
  end

  def download
    q = Student.includes(:interview, user: :identification).ransack(params[:q])
    students = q.result(distinct: true)
    csv = Student.to_csv(students)
    bom = "\xEF\xBB\xBF".encode(Encoding::UTF_8)
    send_data bom + csv.encode(Encoding::UTF_8), type: 'text/csv'
  end

  def confirm
    @draft = @student.draft.reify
  end

  def approve
    @dependencies = @student.draft.draft_publication_dependencies

    if @dependencies.empty?
      @student.draft.publish!
      StudentMailer.student_approved(@student).deliver_later
      redirect_to admin_student_path(@student), notice: '更新依頼を承認しました'
    else
      redirect_to :back, error: '承認できませんでした'
    end
  end

  def reject
    @dependencies = @student.draft.draft_publication_dependencies

    if @dependencies.empty?
      @student.draft.revert!
      StudentMailer.student_rejected(@student, student_params[:comment]).deliver_later
      redirect_to admin_student_path(@student), notice: '更新依頼を却下しました'
    else
      redirect_to :back, error: '却下できませんでした'
    end
  end

  def change_mail_target
    @student.update!(
      is_mail_target: !@student.is_mail_target
    )
    if @student.is_mail_target
      redirect_to admin_student_path(@student), notice: 'メール対象フラグをONにしました'
    else
      redirect_to admin_student_path(@student), notice: 'メール対象フラグをOFFにしました'
    end
  end

  def card
    render(
      pdf: 'student_card',
      orientation: 'Portrait',
      page_size: 'A4',
      encoding: 'UTF-8'
    )
  end

  def ledger
    render(
      pdf: 'student_ledger',
      orientation: 'Portrait',
      page_size: 'A4',
      encoding: 'UTF-8'
    )
  end

  def identification_record
    render 'ledgers/identification_record', layout: false
  end

  def transactions
    @student_transactions = StudentTransactionRecord.where(student_id: @student.id)
    render layout: false, file: 'mypage/students/transactions/show'
  end

  def enable_reapply
    @student.update_column(:enable_reapply, true)
  end

  def disable_reapply
    @student.update_column(:enable_reapply, false)
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(
      :first_name, :first_name_kana, :last_name, :last_name_kana, :gender, :birth_on, :zip_code, :prefecture_id, :city,
      :address1, :address2, :phone, :phone_mobile, :job, :job_details, :business, :business_details, :company, :phone_company, :email_company, :comment,
      :bank_id, :bank_branch_id, :bank_account_type, :bank_account_number, :bank_account_name, :is_mail_target
    )
  end
end
