class Admin::Projects::CommentsController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_project
  before_action :set_comment, only: [:update, :destroy]

  def index
    @q = Comment.unscoped.includes(:user).where(commentable_type: 'Project', commentable_id: @project.id).ransack(params[:q])
    @comments = @q.result.order(created_at: :desc).page(params[:page]).per(100)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'プロジェクト一覧', admin_projects_path
    add_breadcrumb @project.name, admin_project_path(@project)
    add_breadcrumb 'コメント一覧'
  end

  def update
    @comment.update(status: Comment::S_APPROVED)
    #AdminMailer.project_commented(@project).deliver_later
    redirect_to admin_project_comments_path(@project), notice: '承認しました'
  end

  def destroy
    @comment.destroy!
    redirect_to admin_project_comments_path(@project), notice: '削除しました'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_comment
    @comment = Comment.unscoped.find(params[:id])
  end
end