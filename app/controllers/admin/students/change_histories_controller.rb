class Admin::Students::ChangeHistoriesController < Admin::AdminController
  before_action :set_student

  def edit; end

  def update
    Student.record_timestamps = false

    if @student.update(student_params)
      render :update
    else
      render :edit
    end
  ensure
    Student.record_timestamps = true
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def student_params
    params.require(:student).permit(:change_history)
  end
end