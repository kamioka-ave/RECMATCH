class Mypage::OffersController < Mypage::MypageController
  before_action :set_student_offer, only: [:index]
  before_action :set_project, only: [:index]
  before_action :set_meet, only: [:approve, :new_make_date, :confirm_make_date, :change_make_date, :cancel, :meet_done]
  layout 'mypage_student'

  def index; end

  def update
    @offer = Offer.find(params[:id])

    if params.key?(:submit)
      @offer.status = Offer::S_APPROVE
      @meet = ProjectMeet.new
      @meet.project_offer_id = @offer.id
      @meet.project_id = @offer.project_id
      @meet.company_id = @offer.company_id
      @meet.student_id = @offer.student_id
      if @meet.save && @offer.save
        CompanyMailer.offer_approve(@offer).deliver_later
        redirect_to mypage_offers_path, notice: 'オファーを承諾しました'
      else
        redirect_to mypage_offers_path, alert: '更新に失敗しました'
      end
    elsif params.key?(:reject)
      @offer.status = Offer::S_REJECT
      if @offer.save
        redirect_to mypage_offers_path, notice: 'オファーを拒否しました'
      else
        redirect_to mypage_offers_path, alert: '更新に失敗しました'
      end
    end

  end

  def new_make_date;end

  def confirm_make_date
    @meet.attributes = meet_params
    if @meet.save
      StudentMailer.set_meeting_from_company(@meet).deliver_later
      redirect_to mypage_company_applicants_path, notice: '面談日程を登録しました'
    else
      render :new_make_date
    end
  end

  def change_make_date
    if @meet.update(meet_params)
      redirect_to mypage_company_applicants_path, notice: '面談日程を更新しました'
    else
      render :new_make_date
    end
  end

  def cancel
    @meet.status = ProjectMeet::S_CANCEL
    @meet.start = nil
    @meet.end = nil
    if @meet.save
      redirect_to mypage_company_applicants_path, notice: '面談をキャンセルしました'
    else
      redirect_to mypage_company_applicants_path, alert: '更新に失敗しました'
    end
  end

  def finish
    @applicant = Project::Applicant.find(params[:id])
    @applicant.status = Project::Applicant::S_FINISH
    if @applicant.save
      redirect_to mypage_company_applicants_path, notice: 'オファーを却下しました'
    else
      redirect_to mypage_company_applicants_path, alert: '更新に失敗しました'
    end
  end

  def meet_done
    @meet.status = ProjectMeet::S_FINISH
    if @meet.save
      redirect_to mypage_company_applicants_path, notice: '面談を完了にしました。'
    else
      redirect_to mypage_company_applicants_path, alert: '更新に失敗しました'
    end
  end

  private

  def set_student_offer
    @offers = Offer.where(student_id: current_user.student.id)
  end

  def set_offer
    @order = Order.find(params[:id])
  end

  def set_project
    @projects = Project::Applicant.where(student_id: current_user.student.id)
  end

  def set_meet
    @meet = ProjectMeet.find(params[:id])
  end

  def meet_params
    params.require(:project_meet).permit(:status, :start, :end)
  end
end