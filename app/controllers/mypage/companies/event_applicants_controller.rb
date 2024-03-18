class Mypage::Companies::EventApplicantsController < Mypage::MypageController
  before_action :set_applicant, only: [:update, :finish, :wait]
  layout 'mypage_company'

  def index
    @events = Event.where('company_id = ? AND start > ?', current_user.company.id, Time.zone.now)
  end

  def update
    @applicant.status = EventApplicant::S_APPROVE
    if @applicant.save
      StudentMailer.event_approve_from_company(@applicant).deliver_later
      redirect_to mypage_company_event_applicants_path, notice: '参加を承諾しました。'
    else
      redirect_to mypage_company_event_applicants_path, alert: '更新に失敗しました'
    end
  end

  def finish
    @applicant.status = EventApplicant::S_REJECTED
    if @applicant.save
      redirect_to mypage_company_event_applicants_path, notice: '参加を却下しました'
    else
      redirect_to mypage_company_event_applicants_path, alert: '更新に失敗しました'
    end
  end

  def wait
    @applicant.status = EventApplicant::S_SELECTION
    if @applicant.save
      redirect_to mypage_company_event_applicants_path, notice: '検討登録しました。イベント開催日までにご対応お願いします'
    else
      redirect_to mypage_company_event_applicants_path, alert: '更新に失敗しました'
    end
  end

  private

  def set_applicant
    @applicant = EventApplicant.find(params[:id])
  end

end