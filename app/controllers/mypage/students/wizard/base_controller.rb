class Mypage::Students::Wizard::BaseController < Mypage::MypageController
  before_action :check_student_status

  private

  def check_student_status
    if current_user.student.present?
      status = current_user.student.status
      if !(status == Student::S_NEW || status == Student::S_REJECTED || (status == Student::S_IN_REVIEW && request.fullpath == '/mypage/student/wizard/thanks') || (status == Student::S_ACTIVATED && request.fullpath == '/mypage/student/wizard/thanks'))
        redirect_to mypage_root_path
      end
    end
  end
end