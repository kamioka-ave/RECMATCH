class Mypage::AppointmentController < Mypage::MypageController
  before_action :set_student_offer, only: [:index]
  before_action :set_meet, only: [:new_make_date, :confirm_make_date, :change_make_date, :cancel]
  layout 'mypage_student'

  def update
    @meet = ProjectMeet.find(params[:id])
    if params.key?(:submit)
      @meet.status = ProjectMeet::S_APPROVE
      if @meet.save
        redirect_to mypage_offers_path, notice: '面談を承諾しました'
      else
        redirect_to mypage_offers_path, alert: '更新に失敗しました'
      end
    elsif params.key?(:reject)
      @offer.status = Offer::S_CANCEL
      if @offer.save
        redirect_to mypage_offers_path, notice: '面談を拒否しました'
      else
        redirect_to mypage_offers_path, alert: '更新に失敗しました'
      end
    end
  end

  private

  def set_student_offer
    @offers = Offer.where(student_id: current_user.student.id)
  end

  def set_offer
    @order = Order.find(params[:id])
  end

  def set_meet
    @meet = ProjectMeet.find_by(project_offer_id: params[:id])
  end

  def meet_params
    params.require(:project_meet).permit(:status, :start, :end)
  end
end