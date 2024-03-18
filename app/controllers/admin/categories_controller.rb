class Admin::CategoriesController < Admin::AdminController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)

    if @category.save
      @categories = Category.all
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      @categories = Category.all
    else
      render :edit
    end
  end

  def destroy
    name = @category.name

    begin
      @category.destroy!
      flash[:notice] = "#{name}を削除しました"
    rescue => e
      flash[:error] = e.message
    end

    redirect_to admin_categories_url
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
