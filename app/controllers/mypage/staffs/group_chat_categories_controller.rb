class Mypage::Staffs::GroupChatCategoriesController < Mypage::MypageController
  layout 'mypage_staff'
  before_action :set_staff
  before_action :set_company, only: :show

  def index
    @group_chat_categories = @staff.group_chat_categories.order(:ranking)
    @mentions = CompanySupporter::Message.mention_messages(@staff.id, 'Staff').order(created_at: :desc)
  end

  def show
    @group_chat_category = GroupChat::Category.find(params[:id])
    staff_group_chat_category = @staff.staff_group_chat_categories.find_by(group_chat_category: @group_chat_category)
    return render_404 unless staff_group_chat_category
    @group_chat = @company.find_or_create_group_chat(@group_chat_category)
    @messages = @group_chat.messages.reverse_page(params[:page])
    @group_chat.mark_all_as_read_for(@staff)
  end

  private

  def set_staff
    @staff = current_user.staff
  end

  def set_company
    @company = current_user.staff.company
  end
end
