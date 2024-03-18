class Admin::Students::UnlocksController < Admin::AdminController
  before_action :set_student

  def edit; end

  def update
    @student.locked_at = nil
    @student.lock_reason = nil
    @student.reconfirmed_at = Time.now if @student.reconfirmed_at.blank?
    @student.save!
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end
end