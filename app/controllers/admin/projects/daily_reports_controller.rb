class Admin::Projects::DailyReportsController < Admin::AdminController
  before_action :set_project

  def exec
    @type = DailyReport::T_EXEC
    @report_on = @project.execution_at.to_date
    @orders = NormalOrder.includes(:student, project: :company)
                .where(project_id: @project.id, parent_id: nil)
                .where.not(status: [NormalOrder::S_CANCEL])
    render_pdf
  end

  def lost
    @type = DailyReport::T_LOST
    @report_on = @project.lost_at.to_date
    @orders = NormalOrder.includes(:lost_orders, :student, project: :company)
                .where(project_id: @project.id, parent_id: nil)
                .where.not(status: NormalOrder::S_CANCEL)
    render_pdf
  end

  def deliv
    @type = DailyReport::T_DELIV
    @report_on = @project.deliv_at.to_date
    @orders = NormalOrder.includes(:lost_orders, :student, project: :company)
                .where(project_id: @project.id)
                .where.not(status: [NormalOrder::S_CANCEL, NormalOrder::S_LOST])
    render_pdf
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def render_pdf
    render(
      pdf: 'daily_report',
      template: 'admin/projects/daily_reports/body',
      orientation: 'Landscape',
      page_size: 'A4',
      encoding: 'UTF-8',
      viewport_size: '800x600',
      dpi: 96,
      margin: {
        top: 40,
        bottom: 44
      },
      header:  {
        spacing: 7,
        html: {
          template: 'admin/projects/daily_reports/header'
        }
      },
      footer: {
        spacing: 5,
        html: {
          template: 'admin/projects/daily_reports/footer'
        }
      }
    )
  end
end
