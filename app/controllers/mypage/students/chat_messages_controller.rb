class Mypage::Students::ChatMessagesController < Mypage::MypageController
  before_action :set_can_send_companies, only: [:index]
  layout 'mypage_student'

  def index;end

  def show
    @contents = ChatMessage.where('student_id = ? AND company_id = ?', current_user.student.id, params[:id]).order(created_at: 'asc')
    @student_id = current_user.student.id
    @company_id = params[:id]

    @kidoku = ChatMessage.where('student_id = ? AND company_id = ? AND direct = ? AND kidoku = ?', current_user.student.id, params[:id],false , false)

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
    @can_send_companies = ProjectMeet.select("company_id").where('student_id = ?', current_user.student.id).group(:company_id)
  end

  def message_params
    params.require(:chat_message).permit(:student_id,:company_id,:direct,:description)
  end
end