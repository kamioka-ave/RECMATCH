class Mypage::EmailsController < Mypage::MypageController
  layout 'mypage'

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to mypage_root_path, notice: 'メールアドレス変更確認のメールを送信しました。'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end