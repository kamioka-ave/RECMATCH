class Admin::QuestionCategoriesController < Admin::AdminController
  before_action :set_question_category, only: [:edit, :update, :destroy]

  def index
    @question_categories = QuestionCategory.all
  end

  def new
    @question_category = QuestionCategory.new
  end

  def edit; end

  def create
    @question_category = QuestionCategory.new(question_category_params)

    if @question_category.save
      redirect_to admin_question_categories_path, notice: 'よくある質問のカテゴリーを登録しました'
    else
      render :new
    end
  end

  def update
    if @question_category.update(question_category_params)
      redirect_to admin_question_categories_path, notice: 'よくある質問のカテゴリーを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @question_category.destroy
    redirect_to admin_question_categories_url, notice: 'よくある質問のカテゴリーを削除しました'
  end

  private

  def set_question_category
    @question_category = QuestionCategory.find(params[:id])
  end

  def question_category_params
    params.require(:question_category).permit(:type, :name, :rank)
  end
end
