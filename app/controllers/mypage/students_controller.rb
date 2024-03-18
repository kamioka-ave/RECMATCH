class Mypage::StudentsController < Mypage::MypageController
  before_action :set_student, only: [:edit, :update, :activate, :details, :applicants, :reconfirm]
  before_action :set_user, only: [:details]
  layout 'mypage_student', only: [:edit, :update, :activate, :applicants, :reconfirm]
  layout 'mypage', only: [:details]

  def update
    history = StudentHistory.new_with_student(@student)
    @student.attributes = student_params

    if @student.valid?(:registration)
      if @student.changed?
        is_need_lock_and_notify = @student.need_lock_and_notify?

        if is_need_lock_and_notify
          @student.locked_at = Time.now
          @student.lock_reason = @student.lock_reason.present? ? "#{@student.lock_reason}\n学生申請内容が更新されたため" : '学生申請内容が更新されたため'
        end

        @student.revision += 1

        ActiveRecord::Base.transaction do
          history.save!
          @student.save!
        end

        if is_need_lock_and_notify
          #AdminMailer.student_updated(@student).deliver_later
        end
      end

      redirect_to details_mypage_student_path, notice: '学生申請内容を更新しました'
    else
      render :edit
    end
  end

  def activate
    @student.activation_code_input = student_params[:activation_code_input]

    if @student.activate!
      StudentMailer.activated(@student).deliver_later
      redirect_to mypage_student_path, notice: 'アクティベーションが成功しました'
    else
      render 'mypage/pages/student_waiting_activation', layout: 'application'
    end
  end

  def details
    @change_notification = @student.change_notifications.last
    @edit_path = mypage_student_edit_wizard_student_path

  end

  def applicants
    @applicants = Project::Applicant.where(student_id: @student.id).page(params[:page]).per(30)
  end

  def reconfirm
    @student.reconfirm_applied_at = Time.now

    if @student.suitable?
      @student.reconfirmed_at = Time.now
    else
      @student.locked_at = Time.now
      @student.lock_reason = @student.lock_reason.present? ? "#{@student.lock_reason}\n学生適合性確認が不適合" : '学生適合性確認が不適合'
    end

    @student.save!(validate: false)

    redirect_to mypage_root_path, notice: 'ご協力ありがとうございました'
  end

  private

  def set_student
    @student = current_user.student
  end

  def set_user
      @user = current_user
    end

  def student_params
    params.require(:student).permit(
    :first_name, :first_name_kana, :last_name, :last_name_kana, :nickname, :gender, :birth_on, :zip_code, :prefecture_id, :city, :address1, :address2,
    :phone, :phone_mobile, :university, :university_name, :bunri, :depart,:graduation_year, :graduation_month, :labo, :circle, :club, :industry_1, :industry_2, :industry_3,
    :occupation_1, :occupation_2, :occupation_3, :jobhuntingaxis_text, :jobhuntingaxis, :intern_is, :intern_company, :intern_detail, :toeic_score, :mypr, :qualifications
    )
  end
end
