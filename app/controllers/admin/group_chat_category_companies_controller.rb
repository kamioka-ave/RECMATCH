class Admin::GroupChatCategoryCompaniesController < Admin::AdminController
  before_action :set_group_chat_category, :set_company, :set_breadcrumb, only: :show

  def show
    @companies = Company.chat_on.select(:id, :name).as_json(only: [:id, :name], without_avatar: true)
    @consultations = @company.consultations.by_category(@group_chat_category.id).includes(:supporter)
  end

  private

  def set_group_chat_category
    @group_chat_category = GroupChat::Category.find params[:group_chat_category_id]
  end

  def set_company
    @company = Company.find params[:id]
  end

  def set_breadcrumb
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'カテゴリー一覧', admin_group_chat_categories_path
    add_breadcrumb 'カテゴリー詳細', admin_group_chat_category_company_path
  end
end
