class Mypage::PagesController < Mypage::MypageController
  def index
    if current_user.has_role? :company
      if current_user.company.status == Company::S_APPLIED
        render :company_applied
      else
        redirect_to mypage_company_path
      end
    elsif current_user.has_role? :student
      case current_user.student.status
        when Student::S_IN_REVIEW
          render :student_in_review
        when Student::S_REJECTED
          render :sorry
        when Student::S_APPROVED
          render :student_approved
        when Student::S_WAITING_ACTIVATION
          @student = current_user.student
          @student.activation_code = ''
          render :student_waiting_activation
        else
          redirect_to mypage_student_path
      end
    elsif current_user.has_role? :supporter
      redirect_to mypage_supporter_path
    elsif current_user.has_role? :staff
      redirect_to mypage_staff_path
    end
  end

  def company
    @company = current_user.company
    return redirect_to mypage_root_path unless @company
    @project = Project.find_by(company_id: @company.id)
    @project_drafts = ProjectDraft.find_by(company_id: @company.id)
    @projects_succeeded = Project.succeeded.where(company_id: @company.id)
    @projects_in_progress = Project.in_process.where(company_id: @company.id)
    @projects_failed = Project.where(company_id: @company.id).where(status: Project::S_FINISH)
    @events = Event.where(company_id: @company.id)
    @headlines = Headline.all.order(created_at: :desc).limit(3)
    @project_meet_rebooks = ProjectMeet.where('company_id = ? AND status = ?',
          current_user.company.id, ProjectMeet::S_ADJUST)
    @project_meet_nobooks = ProjectMeet.where('company_id = ? AND status = ?',
          current_user.company.id, ProjectMeet::S_MATCH)
    render layout: 'mypage_company'
  end

  def student
    @student = current_user.student
    return redirect_to mypage_root_path unless @student
    @headlines = Headline.all.order(created_at: :desc).limit(3)
    @reports = Report.where(user_id: current_user.id)
                 .order(created_at: :desc).limit(5)
    @offers = Offer.where('student_id = ? AND status = ? AND closing_date >= ?',
      current_user.student.id, Offer::S_NEW, Time.zone.now.midnight)
    @events = Event.joins(:event_applicant).where('event_applicants.student_id = ? AND event_applicants.status = ? AND events.end > ?',
      current_user.student.id, EventApplicant::S_APPROVE, Time.zone.now)
    @project_meet_nobooks = ProjectMeet.where('student_id = ? AND end > ? AND status = ? OR status = ?',
      current_user.student.id, Time.zone.now, ProjectMeet::S_CONTACT, ProjectMeet::S_ADJUST)
    @project_meets = ProjectMeet.where('student_id = ? AND status = ? AND end > ?',
          current_user.student.id, ProjectMeet::S_APPROVE, Time.zone.now)
      render layout: 'mypage_student'

  end

  def events
    @events = Event.joins(:event_applicant).where('event_applicants.student_id = ? AND event_applicants.status = ?',
      current_user.student.id, EventApplicant::S_APPROVE)

    respond_to do |format|
      format.json {
        render json:
        @events.to_json(
          only: [:title, :start, :end, :id]
        )
      }
    end
  end

  def projects
    @projects = ProjectMeet.where('student_id = ? AND status = ? OR status = ?',
      current_user.student.id, ProjectMeet::S_CONTACT, ProjectMeet::S_APPROVE)

    respond_to do |format|
      format.json {
        render json:
        @projects.to_json(
          only: [:project_id, :start, :end, :id]
        )
      }
    end
  end

  def projects
    flash[:notice] = "aaa"
  end

  def account
    render layout: 'mypage'
  end

end
