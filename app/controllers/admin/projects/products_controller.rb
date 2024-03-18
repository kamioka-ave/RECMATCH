class Admin::Projects::ProductsController < Admin::AdminController
  before_action :set_project
  before_action :set_product, only: [:edit, :update, :destroy]

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)
    @product.project_id = @project.id
    @product.price = @project.stock_price * @product.stocks

    unless @product.valid?
      @product.image.cache! if @product.image.present?
      return render :new
    end

    if @product.save
      render :create
    else
      @product.image.cache! if @product.image.present?
      render :new
    end
  end

  def update
    @product.assign_attributes(product_params)
    @product.price = @project.stock_price * @product.stocks

    unless @product.valid?
      @product.image.cache! if @product.image.present?
      return render :edit
    end

    if @product.save
      render :update
    else
      @product.image.cache! if @product.image.present?
      render :edit
    end
  end

  def destroy
    @product.destroy!
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :description, :stocks, :incentive, :image, :image_cache)
  end
end
