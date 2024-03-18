class PagesController < ApplicationController
  def index
    @headlines = Headline.all.active.limit(5)
    @pickup_projects = Project.includes(:company)
                      .where(status: [Project::S_ACTIVE, Project::S_REJECTED, Project::S_FINISH])
                      .where.not('end_at < ?', Time.now)
                      .order(created_at: :desc).limit(4)
    @pickup_events = Event.includes(:company)
                        .where(status: [Event::E_OPEN, Event::E_END])
                        .where.not('end < ?', Time.now)
                        .order(created_at: :desc).limit(4)
    @executed_projects = ExecutedProject.includes(project: [:company, :categories, :products]).all.order(:rank).limit(8)
    sliders = Slider.includes(:headline, project: [:company]).all.order(:rank)

    @pickup_students = Student.all.order(created_at: :desc).limit(16) if user_signed_in? && current_user.has_role?(:company)

    project_ids = []

    sliders.each do |s|
      if !s.project_id.nil? &&  !s.project.can_display?
        project_ids.push(s.project_id)
      end
    end

    if project_ids.length > 0
      @sliders = sliders.where.not(project_id: [project_ids]) + sliders.where.not(slider_type: 'Project')
    else
      @sliders = sliders
    end

    unless user_signed_in?
      @site = Site.find(1)
      @user = User.new
      @user.build_profile
      @user.profile.name = '名無し'
      @role = Role::R_INVESTOR
    end

    render layout: 'top'
  end

  def show
    @page = Page.friendly.find(params[:id])

    if @page.page_type == PageDraft::T_WITH_HEADER
      @container = false
      render :show
    else
      render :show_without_header, layout: false
    end
  rescue
    render_404
  end

  def preview
    if request.post?
      @page = Page.new(preview_params)
      @page.created_at = Time.now
      @page.updated_at = @page.created_at
    else
      @page = PageDraft.find(params[:id])
    end

    if @page.page_type == PageDraft::T_WITH_HEADER
      @container = false
      render :show
    else
      render :show_without_header, layout: false
    end
  end

  def health
    render text: 'ok'
  end

  def about
    @site = Site.find(1)
    @executed_project_count = Project.where(status: Project::S_ACTIVE).count
  end

  def about_company
    @students = Student.all
    @student_interests = StudentInterest.all
  end

  private

  def preview_params
    params.require(:page_draft).permit(
      :page_type, :title, :head, :body, :description, :keywords
    )
  end
end
