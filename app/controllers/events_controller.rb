class EventsController < ApplicationController
  protect_from_forgery except: 'parts'
  before_action :set_event, only: [:show, :parts, :reached, :notice]
  before_action :authenticate_user!, only: [:reached]

  def index
    @events = Event.includes(:company)
                .where(status: Event::E_OPEN)
                .where('(start > ?)', Time.now)
                .where.not('(end < ?)', Time.now)
                .page(params[:page]).per(30)
    @new_arrivals = @events.order(created_at: :desc).limit(4)
    @has_condition = params.key?(:order) || params.key?(:category) || params.key?(:keyword)

    if !@has_condition && @new_arrivals.present?
      @new_arrivals.each do |n|
        @events = @events.where.not(id: n)
      end
    end

    if params.key?(:order)
      if params[:order] == 'limit'
        @keyword = '開催日が近いイベント'
        @events = @events.where.not('(end < ?)', Time.zone.now).order(start: :asc)
      elsif params[:order] == 'new'
        @keyword = '新着イベント'
        @events = @events.order('created_at desc')
      #elsif params[:order] == 'in_progress'
      #  @events = @events.where(status: Event::E_OPEN)
      end
    else
      @events = @events.order(created_at: :desc)
    end

    if params.key?(:category)
      @keyword = 'カテゴリ'
      @events = @events.where(event_type: params[:category])
    end

    if params.key?(:keyword) && params[:keyword].present?
      @keyword = params[:keyword]
      @events = @events.where(
        'title like :keyword or description like :keyword or address like :keyword or id IN (SELECT id from reports where sheet like :keyword)',
        keyword: "%#{Event.sanitize_sql_like(@keyword)}%"
      )
    end

    add_breadcrumb 'トップ', '/'
    add_breadcrumb 'イベントを探す', events_path
  end

  def show
    @company = Company.find(@event.company_id)
    @otherevent = Event.where(company_id: @event.company_id)

    add_breadcrumb 'トップ', '/'
    add_breadcrumb 'イベントを探す', events_path
    add_breadcrumb @event.title
  end

  def hot
    @events = Event.all
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
    @events = Project.all.order(created_at: :desc).limit(10)
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

  def set_event
    @event = Event.find(params[:id])
  end
end
