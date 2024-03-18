class Admin::Students::IntroducesController < Admin::AdminController
  before_action :set_student

  def edit
    render :edit
  end

  def update
    if @student.update(student_params)
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
    params.require(:student).permit(:introduce)
  end
end