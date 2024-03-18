class Projects::HeadlinesController < ApplicationController
  before_action :set_project

  def index
    @headlines = ProjectHeadline.where(project_id: @project.id).page(params[:page]).per(20)
    add_breadcrumb 'トップ', '/'
    add_breadcrumb @project.name, project_path(@project)
    add_breadcrumb 'お知らせ'
  end

  def show
    @headline = ProjectHeadline.find(params[:id])
    add_breadcrumb 'トップ', '/'
    add_breadcrumb @project.name, project_path(@project)
    add_breadcrumb 'お知らせ', project_headlines_path(@project)
    add_breadcrumb @headline.name
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end