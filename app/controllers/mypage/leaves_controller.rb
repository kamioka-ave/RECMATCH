class Mypage::LeavesController < Mypage::MypageController
  layout 'mypage'

  def show
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

    if @profile.update(profile_params)
      UserMailer.leaving_submitted(@profile).deliver_now
      redirect_to edit_mypage_profile_path, notice: '退会申請を行いました。退会が完了するまでしばらくお待ちください。'
    else
      render :show
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:is_leave)
  end
end