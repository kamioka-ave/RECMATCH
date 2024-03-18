class Admin::Projects::ShareholdersController < Admin::AdminController
  before_action :set_project

  def show
    workbook = @project.build_sharebolders_workbook
    s = workbook.stream
    filename = "students_list_#{Time.zone.now.strftime('%Y-%m-%d')}.xlsx"
    send_data(
      s.read,
      filename: filename,
      disposition: 'attachment',
      type: 'application/octet-stream'
    )
  end

  def closed
    csv = @project.closed_shareholders_csv
    bom = "\xEF\xBB\xBF".encode(Encoding::UTF_8)
    send_data(
      bom + csv.encode(Encoding::UTF_8),
      filename: "closed_student_list_p#{@project.id}.csv",
      disposition: 'attachment',
      type: 'text/csv'
    )
  end

  def executed
    csv = @project.executed_shareholders_csv
    bom = "\xEF\xBB\xBF".encode(Encoding::UTF_8)
    send_data(
      bom + csv.encode(Encoding::UTF_8),
      filename: "executed_student_list_p#{@project.id}.csv",
      disposition: 'attachment',
      type: 'text/csv'
    )
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
