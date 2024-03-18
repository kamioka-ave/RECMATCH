class Admin::GroupChatCategoryCompanyMessagesController < Admin::AdminController
  before_action :set_group_chat_category, :set_company

  def index
    set_breadcrumb
    @messages = @group_chat_category.group_chats.with_member(@company).take.messages.includes(:sender).newest.page(params[:page])
  end

  private

  def set_group_chat_category
    @group_chat_category = GroupChat::Category.find params[:group_chat_category_id]
  end

  def set_company
    @company = Company.find params[:company_id]
  end

  def set_breadcrumb
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'カテゴリー一覧', admin_group_chat_categories_path
    add_breadcrumb 'カテゴリー詳細', admin_group_chat_category_company_path(params[:group_chat_category_id], params[:company_id])
    add_breadcrumb "#{@group_chat_category.name}と#{@company.name}のメッセージ", admin_group_chat_category_company_messages_path(params[:group_chat_category_id], company_id: params[:company_id])
  end
end
