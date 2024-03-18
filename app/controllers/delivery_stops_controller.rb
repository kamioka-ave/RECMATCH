class DeliveryStopsController < ApplicationController
  before_action :set_user, only: [:show, :update]

  def show;end

  def update
    @user.assign_attributes(user_params)
    return redirect_to mypage_root_path, notice: '配信設定を更新しました' if @user.save
    render :show
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email_stop)
  end

end