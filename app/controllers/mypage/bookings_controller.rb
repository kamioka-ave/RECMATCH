class Mypage::BookingsController < Mypage::MypageController

  layout 'mypage_student'

  def show
    #@events = Event.joins(:event_applicant).where(event_applicants: {student_id: current_user.student}).where("events.end > ?", Time.zone.now)
    @events = EventApplicant.joins(:event).where('student_id = ? AND events.end > ?', current_user.student.id, Time.zone.now )
    @meets = ProjectMeet.where('student_id = ? AND end > ?',
               current_user.student.id, Time.zone.now)
  end

  private
end