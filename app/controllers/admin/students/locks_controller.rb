class Admin::Students::LocksController < Admin::AdminController
  before_action :set_student

  def edit; end

  def update
    @student.assign_attributes(student_params)
    @student.locked_at = Time.now

    if @student.save(context: :lock)
      render :update
    else
      render :edit
    end
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def student_params
    params.require(:student).permit(:locked_at, :lock_reason)
  end
end