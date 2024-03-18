class Admin::Students::StatusHistoriesController < Admin::AdminController
  before_action :set_student

  def index
    @status_histories = StudentStatusHistory.where(student_id: @student.id)
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end
end