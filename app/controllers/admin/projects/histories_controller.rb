class Admin::Projects::HistoriesController < Admin::AdminController
  before_action :set_project

  def index
    @histories = ProjectHistory.where(project_draft_id: @draft.id)
                   .where.not(revision: @draft.revision)
  end

  def show
    @history = ProjectHistory.where(project_draft_id: @draft.id, revision: params[:id]).first
  end

  private

  def set_project
    @draft = ProjectDraft.find(params[:project_id])
  end
end