class Mypage::Students::EditWizard::StudentsController < Mypage::MypageController
  before_action :set_student

  def show
    unless @student.change_notification.nil?
      @student.merge_change_notification
    end
  end

  def update
    @profile = current_user.profile

    if @student.update!(student_params) && @profile.update(name: student_params[:nickname])
      #@student.reload

      #if @student.change_notification.present?
      #  if @student.change_notification.need_identification?
      #    redirect_to mypage_student_edit_wizard_identification_path
      #  else
      #    redirect_to mypage_student_edit_wizard_change_notification_path
      #  end
      #else
      redirect_to details_mypage_student_path, notice: '学生申請内容を更新しました'
    else
      render :show
    end
  end

  private

  def set_student
    @student = current_user.student
  end

  def student_params
    params.require(:student).permit(
    :first_name, :first_name_kana, :last_name, :last_name_kana, :nickname, :gender, :birth_on, :zip_code, :prefecture_id, :city, :address1, :address2,
    :phone, :phone_mobile, :university, :university_name, :bunri, :depart,:graduation_year, :graduation_month, :labo, :circle, :club, :industry_1, :industry_2, :industry_3,
    :occupation_1, :occupation_2, :occupation_3, :jobhuntingaxis_text, :jobhuntingaxis, :intern_is, :intern_company, :intern_detail, :toeic_score, :mypr, :qualifications
    )
  end
end
