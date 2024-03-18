class Admin::Projects::HeadlinesController < Admin::AdminController
  before_action :set_project
  before_action :set_headline, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @headline = ProjectHeadline.new
  end

  def edit; end

  def create
    @headline = ProjectHeadline.new(project_headline_params)

    unless @headline.save
      return render :new
    end

    user_ids = NormalOrder.where(project_id: @project.id).where.not(status: [NormalOrder::S_CANCEL, NormalOrder::S_LOST]).pluck(:user_id)
    Student.where(user_id: user_ids).each do |i|
      StudentMailer.project_headline_created(@headline, i).deliver_later
    end
  end

  def update
    unless @headline.update(project_headline_params)
      render :edit
    end
  end

  def destroy
    @headline.destroy!
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_headline
    @headline = ProjectHeadline.find(params[:id])
  end

  def project_headline_params
    params.require(:project_headline).permit(:project_id, :user_id, :admin_id, :name, :body)
  end
end
