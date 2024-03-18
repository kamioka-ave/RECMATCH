class Admin::HeadlinesController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_headline, only: [:edit, :update, :destroy]

  def index
    @q = Headline.ransack(params[:q])
    @headlines = @q.result.page(params[:page]).per(30)
  end

  def new
    @headline = Headline.new
  end

  def edit; end

  def create
    @headline = Headline.new(headline_params)

    if params.key?(:preview) && @headline.valid?
      @headline.created_at = @headline.updated_at = Time.zone.now
      response.headers['X-XSS-Protection'] = '0'
      render file: 'headlines/show', layout: 'application'
    elsif @headline.valid?
      @headline.status = params.key?(:draft) ? Headline::S_DRAFT : Headline::S_PUBLISHED
      @headline.save!
      redirect_to admin_headlines_path, notice: 'NEWSを作成しました'
    else
      render :new
    end
  end

  def update
    if params.key?(:preview) && @headline.valid?
      @headline.attributes = headline_params
      response.headers['X-XSS-Protection'] = '0'
      render file: 'headlines/show', layout: 'application'
    elsif params.key?(:draft) && @headline.update(headline_params)
      redirect_to admin_headlines_path, notice: '下書きを更新しました'
    elsif @headline.valid?
      @headline.status = Headline::S_PUBLISHED
      @headline.update!(headline_params)
      redirect_to admin_headlines_path, notice: 'NEWSを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @headline.destroy
    redirect_to admin_headlines_path, notice: 'NEWSを削除しました'
  end

  private

  def set_headline
    @headline = Headline.unscoped.find(params[:id])
  end

  def headline_params
    params.require(:headline).permit(:title, :body, :headline_type, :published_at)
  end
end
