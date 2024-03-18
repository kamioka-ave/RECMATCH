class Admin::Students::ChangeNotificationsController < Admin::AdminController
  before_action :set_student
  before_action :set_change_notification, only: [:show, :destroy, :dm, :sent_dm, :lock, :dm_locked, :sent_dm_locked, :confirm]

  def index
    @change_notifications = Student::ChangeNotification.where(student_id: @student.id)
                              .where.not(status: Student::ChangeNotification::S_NEW)
                              .order(notified_at: :desc)
  end

  def show
    render(
      pdf: 'change_notification',
      orientation: 'Portrait',
      page_size: 'A4',
      encoding: 'UTF-8'
    )
  end

  def new
    @change_notification = Student::ChangeNotification.new
  end

  def create
    @change_notification = Student::ChangeNotification.new(change_notification_params)

    if @change_notification.valid?(:upload) && @change_notification.save
      @change_notifications = Student::ChangeNotification.where(student_id: @student.id)
                                .where.not(status: Student::ChangeNotification::S_NEW)
                                .order(notified_at: :desc)
    else
      render :new
    end
  end

  def destroy
    @change_notification.destroy!
    redirect_to admin_student_path(@student), notice: '変更届を削除しました'
  end

  def dm
    render layout: false
  end

  def sent_dm
    @change_notification.update!(
      dm_sent_at: Time.zone.now,
      status: Student::ChangeNotification::S_SENT_DM
    )
    StudentMailer.change_sent_dm(@student).deliver_later
    redirect_to admin_student_path(@student), notice: 'DM発送済みにしました'
  end

  def lock
    @change_notification.update!(
      locked_at: Time.zone.now,
      status: Student::ChangeNotification::S_LOCKED
    )
    redirect_to admin_student_path(@student), notice: '申込みをロックしました'
  end

  def dm_locked
    render layout: false
  end

  def sent_dm_locked
    @change_notification.update!(
      confirmation_code_sent_at: Time.zone.now,
      status: Student::ChangeNotification::S_WAITING_CONFIRMATION
    )
    redirect_to admin_student_path(@student), notice: 'ロック解除DM発送済みにしました'
  end

  def confirm
    @change_notification.update!(
      confirmed_at: Time.zone.now,
      status: Student::ChangeNotification::S_CONFIRMED
    )
    redirect_to admin_student_path(@student), notice: 'ロックを解除しました'
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def set_change_notification
    @change_notification = Student::ChangeNotification.find(params[:id])
  end

  def change_notification_params
    params.require(:student_change_notification).permit(
      :student_id, :notified_at, :file, :status
    )
  end
end