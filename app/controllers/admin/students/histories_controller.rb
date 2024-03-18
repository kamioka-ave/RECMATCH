class Admin::Students::HistoriesController < Admin::AdminController
  before_action :set_student

  def index
    @histories = StudentHistory.where(student_id: @student.id)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '学生一覧', admin_students_path
    add_breadcrumb @student.full_name, admin_student_path(@student)
    add_breadcrumb '学生申請内容の履歴'
  end

  def show
    @history = StudentHistory.where(student_id: @student.id, revision: params[:id]).first
    render json: @history.as_json, status: 200
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end
end