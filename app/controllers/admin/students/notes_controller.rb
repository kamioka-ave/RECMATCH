class Admin::Students::NotesController < Admin::AdminController
  before_action :set_student

  def edit; end

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
    params.require(:student).permit(:card_note, :antisocial_checked_at, :antisocial_checker_id, :identified_at, :identifier_id, :approved_at, :approver_id)
  end
end