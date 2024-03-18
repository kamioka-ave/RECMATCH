class Admin::Students::StatusesController < Admin::AdminController
  before_action :set_student, except: :approve

  def approve
    @student = Student.find(params[:student_id])

    if @student.status != Student::S_APPROVED
      @student.approve!(current_admin.id)
      redirect_to admin_student_path(@student), notice: '承認しました'
    else
      redirect_to admin_student_path(@student), error: '既に承認済みです'
    end
  end

  def reject
    if @student.reconfirmed_at.blank?
      @student.reject!
    else
      @student.reject_with_reconfirm!
    end

    redirect_to admin_student_path(@student), notice: '却下しました'
  end

  def reject_without_mail
    @student.reject_without_mail!
    redirect_to admin_student_path(@student), notice: '却下しました'
  end

  def waiting_activation
    @student.start_waiting_activation!
  rescue => e
    @message = e.message
    render :error
  end

  def waiting_dm
    @student.revert_waiting_activation_to_approved!
  rescue => e
    @message = e.message
    render :error
  end

  def dm
    render layout: false
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def student_params
    params.require(:student).permit(:status)
  end
end