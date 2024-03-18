class Mypage::Companies::Staffs::GroupChatCategoriesController < Mypage::MypageController
  before_action :set_staff, :set_company
  before_action :staff_group_chat_category, only: [:destroy, :restore]
  before_action :set_staff_categories, only: [:index, :create]
  before_action :set_group_chat_categories, only: [:new, :create]

  layout "mypage_company"

  def index
  end

  def new
    @staff_group_chat_category = StaffGroupChatCategory.new
  end

  def create
    return redirect_to mypage_company_staff_group_chat_categories_path if @staff.rejected_at.present?
    @current_group_chat_category = GroupChat::Category.find staff_group_chat_category_params[:group_chat_category_id]
    @staff_group_chat_category = @staff.staff_group_chat_categories.new staff_group_chat_category_params
    render :new unless @staff_group_chat_category.save
  end

  def restore
    return redirect_to mypage_company_staff_group_chat_categories_path if @staff.rejected_at.present?
    redirect_to mypage_company_staff_group_chat_categories_path if @staff_group_chat_category.restore
  end

  def destroy
    return redirect_to mypage_company_staff_group_chat_categories_path if @staff.rejected_at.present?
    redirect_to mypage_company_staff_group_chat_categories_path  if @staff_group_chat_category.destroy
  end

  private

  def set_staff_categories
    @categories = @staff.staff_group_chat_categories.includes(:group_chat_category).with_deleted.page(params[:page]).per(10)
  end

  def set_group_chat_categories
    @group_chat_categories = GroupChat::Category.display
  end

  def set_staff
    @staff = Staff.find params[:staff_id]
  end

  def set_company
    @company = current_user.company
  end

  def staff_group_chat_category
    @staff_group_chat_category = StaffGroupChatCategory.with_deleted.find params[:id]
  end

  def staff_group_chat_category_params
    params.require(:staff_group_chat_category).permit(:group_chat_category_id)
  end
end
