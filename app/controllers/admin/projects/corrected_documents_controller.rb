class Admin::Projects::CorrectedDocumentsController < Admin::AdminController
  before_action :set_project
  before_action :set_corrected_document, only: [:destroy]

  def new
    @document = ProjectCorrectedDocument.new(project_id: @project.id)
  end

  def create
    @document = ProjectCorrectedDocument.new(project_corrected_document_params)

    unless @document.save
      render :new
    end
  end

  def destroy
    name = @document.name
    @document.destroy!
    redirect_to admin_project_path(@project), notice: "#{name}を削除しました"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_corrected_document
    @document = ProjectCorrectedDocument.find(params[:id])
  end

  def project_corrected_document_params
    params.require(:project_corrected_document).permit(
      :project_id, :name, :file
    )
  end
end
