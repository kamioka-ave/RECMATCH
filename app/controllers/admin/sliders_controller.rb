class Admin::SlidersController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_slider, only: [:edit, :update, :destroy]

  def index
    @sliders = Slider.includes(:project).all.order(:rank)
  end

  def new
    @slider = Slider.new
  end

  def edit; end

  def create
    @slider = Slider.new(slider_params)

    if @slider.save
      redirect_to admin_sliders_path, notice: 'トップスライダーを登録しました'
    else
      @slider.image.cache! if @slider.image.present?
      @slider.bg_image.cache! if @slider.bg_image.present?
      render :new
    end
  end

  def update
    if @slider.update(slider_params)
      redirect_to admin_sliders_path, notice: 'トップスライダーを更新しました'
    else
      @slider.image.cache! if @slider.image.present?
      @slider.bg_image.cache! if @slider.bg_image.present?
      render :edit
    end
  end

  def destroy
    @slider.destroy
    redirect_to admin_sliders_path, notice: 'トップスライダーを削除しました'
  end

  private

  def set_slider
    @slider = Slider.find(params[:id])
  end

  def slider_params
    params.require(:slider).permit(
      :slider_type, :project_id, :event_id, :headline_id, :rank, :image, :bg_image
    )
  end
end
