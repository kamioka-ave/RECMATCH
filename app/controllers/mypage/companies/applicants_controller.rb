class Mypage::Companies::ApplicantsController < Mypage::MypageController
  before_action :set_project
  before_action :set_meet, only: [:approve, :new_make_date, :confirm_make_date, :change_make_date, :cancel, :meet_done]
  layout 'mypage_company'

  def index
    @applicants = @project.blank? ?  [] : Project::Applicant.where(project_id: @project.id).where('created_at > ?', Time.zone.now.ago(2.month))
    @offers = Offer.where(company_id: current_user.company.id)
    @project_meet_nobooks = ProjectMeet.where('company_id = ? AND status = ?',
              current_user.company.id, ProjectMeet::S_MATCH)
  end

  def update
    @applicant = Project::Applicant.find(params[:id])
    @applicant.status = Project::Applicant::S_APPROVE
    @meet = ProjectMeet.new
    @meet.project_applicant_id = @applicant.id
    @meet.project_id = @applicant.project_id
    @meet.student_id = @applicant.student_id
    @meet.company_id = current_user.company.id

    if @applicant.save && @meet.save
      StudentMailer.applicant_approve_from_company(@applicant).deliver_later
      redirect_to mypage_company_applicants_path, notice: 'オファーを承諾しました'
    else
      redirect_to mypage_company_applicants_path, alert: '更新に失敗しました'
    end
  end

  def approve
    if @meet.update(status: ProjectMeet::S_APPROVE)
      redirect_to mypage_company_applicants_path, notice: '面談日程の再調整を承諾しました'
    else
      redirect_to mypage_company_applicants_path, alert: '更新に失敗しました'
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

  def set_project
    @project = Project.find_by(company_id: current_user.company.id)
  end

  def set_meet
    @meet = ProjectMeet.find(params[:id])
  end

  def meet_params
    params.require(:project_meet).permit(:status, :start, :end)
  end

end