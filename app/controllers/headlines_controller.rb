class HeadlinesController < ApplicationController
  def index
    @headlines = Headline.active.all

    if params.key?(:type)
      @headlines = @headlines.where(headline_type: params[:type])
    end

    @headlines = @headlines.page(params[:page]).per(20)

    add_breadcrumb 'トップ', '/'
    add_breadcrumb 'NEWS'
  end

  def show
    @headline = Headline.find(params[:id])
    add_breadcrumb 'トップ', '/'
    add_breadcrumb 'NEWS', headlines_path
    add_breadcrumb @headline.title
  end

  def feed
    @headlines = Headline.all.order(created_at: :desc).limit(10)
    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end
