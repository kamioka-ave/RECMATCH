class Mypage::ApplicantsController < Mypage::MypageController
  before_action :set_project, only: [:show]
  before_action :set_event, only: [:show]
  layout 'mypage_student'
  add_flash_types :success, :info, :warning, :danger

  def show
  end

  private

  def set_project
    @projects = Project::Applicant.where(student_id: current_user.student.id)
  end

  def set_event
    #@events = Event.joins(:event_applicant).where('event_applicants.student_id = ?', current_user.student.id)
    @events = EventApplicant.joins(:event).where('student_id = ? AND events.end > ?', current_user.student.id, Time.zone.now )
  end

end