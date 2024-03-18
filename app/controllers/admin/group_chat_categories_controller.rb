# coding: utf-8
class Admin::GroupChatCategoriesController < Admin::AdminController
  before_action :set_group_chat_category, only: [:edit, :update]

  def index
    @q = GroupChat::Category.ransack(params[:q])
    @group_chat_categories = @q.result.order(:ranking).page(params[:page]).per(30)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'カテゴリー一覧', admin_group_chat_categories_path
  end

  def new
    @group_chat_category = GroupChat::Category.new
  end

  def create
    @group_chat_category = GroupChat::Category.new group_chat_category_params
    if @group_chat_category.save
      redirect_to admin_group_chat_categories_path, notice: '管理者を追加しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group_chat_category.update group_chat_category_params
      redirect_to admin_group_chat_categories_path, notice: 'サポーター情報を更新しました'
    else
      render :edit
    end
  end

  private

  def set_group_chat_category
    @group_chat_category = GroupChat::Category.find(params[:id])
  end

  def group_chat_category_params
    params.require(:group_chat_category).permit(:name, :icon, :ranking, :status)
  end
end
