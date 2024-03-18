class Admin::ProjectsController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_project, only: [:show, :fail, :abort, :applicants]

  def index
    @q = ProjectDraft.unscoped.includes(:project, :company).order('id DESC').ransack(params[:q])
    @drafts = @q.result.page(params[:page]).per(100)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '採用募集ページ一覧'
  end

  def show
    @students = User.includes(:profile).with_role(:student).map { |student| ["#{student.id}: #{student.name}", student.id] }
    @company = Company.find(params[:id])
    @draft = @project
    @events = Event.where(company_id: @company.id)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '採用募集ページ一覧', admin_projects_path
    add_breadcrumb @project.name
  end

  def applicants
    csv = @project.applicants_csv
    bom = "\xEF\xBB\xBF".encode(Encoding::UTF_8)
    send_data(
      bom + csv.encode(Encoding::UTF_8),
      filename: "applicants_p#{@project.id}.csv",
      disposition: 'attachment',
      type: 'text/csv'
    )
  end

  def fail
    @project.with_lock do
      @project.fail!
    end

    redirect_to admin_projects_path, notice: "#{@project.name}を不成立にしました"
  end

  def abort
    @project.with_lock do
      @project.abort!
    end

    redirect_to admin_projects_path, notice: "#{@project.name}を中止にしました"
  end

  def enable_front_display
    @project.update_column(:enable_front_display, true)
  end

  def disable_front_display
    @project.update_column(:enable_front_display, false)
  end


  private

  def set_project
    @project = Project.find(params[:id])
  end
end
