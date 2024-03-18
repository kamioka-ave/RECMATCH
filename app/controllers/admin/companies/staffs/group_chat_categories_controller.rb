class Admin::Companies::Staffs::GroupChatCategoriesController < Admin::AdminController
  before_action :set_company, :set_staff
  before_action :set_breadcrumb, only: :index
  before_action :set_staff_group_chat_category, only: %i(destroy restore)
  before_action :set_staff_group_chat_categories, only: %i(index create)
  before_action :set_group_chat_categories, only: %i(new create)

  def index
  end

  def new
    @staff_group_chat_category = StaffGroupChatCategory.new
  end

  def create
    @current_group_chat_category = GroupChat::Category.find staff_group_chat_category_params[:group_chat_category_id]
    @staff_group_chat_category = @staff.staff_group_chat_categories.new staff_group_chat_category_params
    render :new unless @staff_group_chat_category.save
  end

  def restore
    redirect_to admin_company_staff_group_chat_categories_path(company_id: @company.id,
      staff_id:@staff_group_chat_category.staff_id) if @staff_group_chat_category.restore
  end

  def destroy
    redirect_to admin_company_staff_group_chat_categories_path(company_id: @company.id, staff_id: @staff_group_chat_category.staff_id) if @staff_group_chat_category.destroy
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_staff
    @staff = Staff.with_deleted.find(params[:staff_id])
  end

  def set_staff_group_chat_category
    @staff_group_chat_category = StaffGroupChatCategory.with_deleted.find(params[:id])
  end

  def set_staff_group_chat_categories
    @staff_group_chat_categories = @staff.staff_group_chat_categories.includes(:group_chat_category).with_deleted.page(params[:page])
  end

  def set_group_chat_categories
    @group_chat_categories = GroupChat::Category.display
  end

  def staff_group_chat_category_params
    params.require(:staff_group_chat_category).permit(:group_chat_category_id)
  end

  def set_breadcrumb
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb '相談用アカウントの追加', admin_company_staffs_path(company_id: @company.id)
    add_breadcrumb '対応カテゴリー詳細'
  end
end
