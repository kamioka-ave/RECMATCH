class Admin::Students::Interviews::HistoriesController < Admin::AdminController
  before_action :set_interview

  def index
    @histories = StudentInterviewHistory.where(student_interview_id: @interview.id)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '学生一覧', admin_students_path
    add_breadcrumb @student.full_name, admin_student_path(@student)
    add_breadcrumb '学生適合性確認の履歴'
  end

  def show
    @history = StudentInterviewHistory.where(student_interview_id: @interview.id, revision: params[:id]).first
    render json: @history.as_json, status: 200
  end

  private

  def set_interview
    @student = Student.find(params[:student_id])
    @interview = @student.interview
  end
end