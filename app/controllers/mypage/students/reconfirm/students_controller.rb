class Mypage::Students::Reconfirm::StudentsController < Mypage::MypageController
  def show
    @student = current_user.student
  end

  def update
    @student = current_user.student

    history = StudentHistory.new_with_student(@student)
    @student.attributes = student_params

    if @student.valid?
      if @student.changed?
        @student.revision += 1
        ActiveRecord::Base.transaction do
          history.save!
          @student.save!
        end
      end
      redirect_to mypage_student_reconfirm_pep_path
    else
      render :show
    end
  end

  private

  def student_params
    params.require(:student).permit(
      :first_name, :first_name_kana, :last_name, :last_name_kana, :gender, :birth_on, :zip_code, :prefecture_id, :city,
      :address1, :address2, :phone, :phone_mobile, :job, :job_details, :business, :business_details, :company, :phone_company, :email_company,
      :bank_id, :bank_branch_id, :bank_account_type, :bank_account_number, :bank_account_name
    )
  end
end
