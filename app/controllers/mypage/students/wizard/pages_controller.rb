class Mypage::Students::Wizard::PagesController < Mypage::Students::Wizard::BaseController
  def show
    @user = current_user
  end

  def thanks
    if request.referer != mypage_student_wizard_confirm_url
      render_404
    else
      @student = current_user.student
    end
  end

  def unconfirmed; end
end