class Admin::Students::LockReasonsController < Admin::AdminController
  before_action :set_student

  def edit; end

  def update
    @student.assign_attributes(student_params)

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
    params.require(:student).permit(:lock_reason)
  end
end