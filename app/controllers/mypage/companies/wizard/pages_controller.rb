class Mypage::Companies::Wizard::PagesController < Mypage::Students::Wizard::BaseController
  def show
    @user = current_user
  end

  def thanks
    if request.referer != mypage_company_wizard_confirm_url
      render_404
    else
      @company = current_user.company
    end
  end

  def unconfirmed; end
end