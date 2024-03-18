class Mypage::Students::ProjectApplicantsController < Mypage::MypageController
  before_action :set_student
  before_action :set_meet, only: [:approve, :cancel, :new_make_date, :change_make_date, :finish]
  layout 'mypage_student'

  def approve
    @meet.status = ProjectMeet::S_APPROVE
    if @meet.save
      redirect_to mypage_booking_path, notice: '面談を承諾しました'
    else
      redirect_to mypage_booking_path, alert: '更新に失敗しました'
    end
  end

  def cancel
    @meet.status = ProjectMeet::S_CANCEL
    if @meet.save
      redirect_to mypage_booking_path, notice: '面談をキャンセルしました'
    else
      redirect_to mypage_booking_path, alert: '更新に失敗しました'
    end
  end

  def new_make_date;end

  def change_make_date
    if @meet.update(meet_params)
      redirect_to mypage_booking_path, notice: '面談日程を更新しました'
    else
      render :new_make_date
    end
  end

  def finish
    @meet.status = ProjectMeet::S_FINISH
    if @meet.save
      redirect_to mypage_booking_path, notice: '面談を拒否しました'
    else
      redirect_to mypage_booking_path, alert: '更新に失敗しました'
    end
  end

  private

  def meet_params
    params.require(:project_meet).permit(:status, :start, :end)
  end

  def set_student
    @student = current_user.student
  end

  def set_meet
    @meet = ProjectMeet.find(params[:id])
  end

end