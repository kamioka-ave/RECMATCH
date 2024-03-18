class Mypage::Companies::ChatMessagesController < Mypage::MypageController
  before_action :set_can_send_companies, only: [:index]
  layout 'mypage_company'

  def index;end

  def show
    @contents = ChatMessage.where('student_id = ? AND company_id = ?', params[:id], current_user.company.id).order(created_at: 'asc')
    @student_id = params[:id]
    @company_id = current_user.company.id
    @kidoku = ChatMessage.where('student_id = ? AND company_id = ? AND direct = ? AND kidoku = ?', params[:id], current_user.company.id, true, false)

    @kidoku.each do |k|
      k.update(kidoku: true)
    end
  end

  def update
    @new_message = ChatMessage.new(message_params)
    unless @new_message.save
      render :show
    end
    render :show
  end

  private

  def set_can_send_companies
    @can_send_companies = ProjectMeet.select("student_id").where(company_id: current_user.company.id).group(:student_id)
  end

  def message_params
    params.require(:chat_message).permit(:student_id,:company_id,:direct,:description)
  end
end