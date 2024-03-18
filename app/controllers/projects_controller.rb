class ProjectsController < ApplicationController
  protect_from_forgery except: 'parts'
  before_action :set_project, only: [:show, :parts, :reached, :notice]
  before_action :authenticate_user!, only: [:reached]

  def index
    @projects = Project.includes(:company)
                .where(status: [Project::S_ACTIVE, Project::S_FINISH])
                .where.not('entry_closed < ?', Time.now)
                .where.not('(start_at > ?) and (end_at < ?)', Time.now, Time.now)
                .page(params[:page]).per(30)
    @new_arrivals = @projects.order(created_at: :desc).limit(4)
    @has_condition = params.key?(:order) || params.key?(:category) || params.key?(:keyword)

    if !@has_condition && @new_arrivals.present?
      @new_arrivals.each do |n|
        @projects = @projects.where.not(id: n)
      end
    end

    if params.key?(:order)
      if params[:order] == 'limit'
        @keyword = 'オファー受付が終了間近の企業'
        @projects = @projects.where('entry_closed < DATE_ADD(NOW(), INTERVAL 1 MONTH)').where.not('(entry_closed < ?)', Time.zone.now).order(entry_closed: :asc)
      elsif params[:order] == 'new'
        @keyword = '新着の企業'
        @projects = @projects.order('created_at desc')
      elsif params[:order] == 'in_progress'
        @keyword = 'オファー受付中の企業'
        @projects = @projects.where(status: Project::S_ACTIVE)
      end
    else
      #@projects = @projects.order("is_pickup_on_top DESC, ABS(TIMEDIFF(finish_at, '#{Time.now.to_formatted_s :db}'))")
      @projects = @projects.order(created_at: :desc)
    end

    if params.key?(:category)
      @keyword = '業界検索'
      @projects = @projects.where("(company_id) IN (SELECT id FROM companies WHERE business_type_id = ?)", params[:category])
    end

    if params.key?(:keyword) && params[:keyword].present?
      @keyword = params[:keyword]
      @projects = @projects.where(
        'name like :keyword or short_description like :keyword or description like :keyword or company_id IN (SELECT id from companies where name like :keyword)',
        keyword: "%#{Project.sanitize_sql_like(@keyword)}%"
      )
    end

    add_breadcrumb 'トップ', '/'
    add_breadcrumb '企業を探す', projects_path
  end

  def show
    unless admin_signed_in? && current_admin.has_any_role?(:admin, :admin_without_mail, :recmatch_business_department, :recmatch_admin)
      if @project.status == Project::S_REJECTED && @project.failed_at < Time.zone.now.ago(3.days)
        flash[:notice] = 'お探しの企業は存在しません'
        return redirect_to root_path, status: :moved_permanently
      end
    end
    @company = Company.find(@project.company_id)
    @events = Event.where(company_id: @company.id, status: Event::E_OPEN)

    add_breadcrumb 'トップ', '/'
    add_breadcrumb '企業を探す', projects_path
    add_breadcrumb @company.name
  end

  def hot
    @projects = Project.all
  end

  def parts
    @width = params[:width].to_i
    render layout: false
  end

  def reached
    @products = Product.where(project_id: @project.id)
                    .where('price <= ?', @project.solicit_limit - @project.solicited)
  end

  def feed
    @projects = Project.all.order(created_at: :desc).limit(10)
    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  def notice
    render(
      template: "projects/notices/notice_v#{@project.contract_before_version}",
      pdf: 'notice',
      orientation: 'Portrait',
      page_size: 'A4',
      encoding: 'UTF-8'
    )
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
