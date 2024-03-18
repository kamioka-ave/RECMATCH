class Admin::Students::Peps::HistoriesController < Admin::AdminController
  before_action :set_pep

  def index
    @histories = StudentPepHistory.where(student_pep_id: @pep.id)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '学生一覧', admin_students_path
    add_breadcrumb @student.full_name, admin_student_path(@student)
    add_breadcrumb '居住地国・外国PEPs・FATCA届出の履歴'
  end

  def show
    @history = StudentPepHistory.where(student_pep_id: @pep.id, revision: params[:id]).first
    render json: @history.as_json, status: 200
  end

  def document
    @history = StudentPepHistory.find(params[:id])
    render(
      pdf: 'pep_document',
      orientation: 'Portrait',
      page_size: 'A4',
      encoding: 'UTF-8'
    )
  end

  private

  def set_pep
    @student = Student.find(params[:student_id])
    @pep = @student.pep
  end
end
