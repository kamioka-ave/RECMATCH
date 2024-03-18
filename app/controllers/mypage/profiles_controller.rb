class Mypage::ProfilesController < Mypage::MypageController
  layout 'mypage'

  def edit
    @profile = current_user.profile
    @user = @profile.user
  end

  def update
    @profile = current_user.profile
    @student = current_user.student


    if @profile.update(profile_params) && @student.update(nickname: profile_params[:name])
      redirect_to mypage_root_path, notice: 'ユーザー情報を更新しました'
    else
      @profile.image.cache! unless @profile.image.blank?
      @user = @profile.user
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:user_id, :name, :name_kana, :description, :image, :receive_notification, :use_social, :image_cache, :company, :tel, :gender, :zip_code)
  end
end
