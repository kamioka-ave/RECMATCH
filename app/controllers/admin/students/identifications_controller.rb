class Admin::Students::IdentificationsController < Admin::AdminController
  before_action :set_student

  def approve
    @student.identify!(current_admin.id)

    if @student.is_antisocial_check_passed
      #AdminMailer.student_ready_to_approve(@student).deliver_later
    end

    redirect_to admin_student_path(@student), notice: '本人確認OKにしました'
  end

  def reject
    @student.reject_with_identification!(current_admin.id)
    redirect_to admin_student_path(@student), notice: '本人確認NGにしました'
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end
end