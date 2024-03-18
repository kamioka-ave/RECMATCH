class Admin::Students::AntisocialsController < Admin::AdminController
  before_action :set_student

  def approve
    @student.update!(
      is_antisocial_check_passed: true,
      antisocial_checked_at: Time.now,
      antisocial_checker_id: current_admin.id
    )

    if @student.is_identification_passed
      #AdminMailer.student_ready_to_approve(@student).deliver_later
    end

    redirect_to admin_student_path(@student), notice: '反社チェックOKにしました'
  end

  def reject
    @student.reject_with_antisocial!(current_admin.id)
    redirect_to admin_student_path(@student), notice: '反社チェックNGにしました'
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end
end