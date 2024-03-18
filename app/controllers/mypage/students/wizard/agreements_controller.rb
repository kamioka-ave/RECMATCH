class Mypage::Students::Wizard::AgreementsController < Mypage::Students::Wizard::BaseController
  def show
    @agreement = current_user.student_agreement.present? ? current_user.student_agreement : StudentAgreement.new

    if current_user.student.present? && current_user.student.status == Student::S_REJECTED && !@agreement.reapplied
      @agreement.pdf1 = false
      @agreement.pdf2 = false
      @agreement.pdf3 = false
      @agreement.agreement = false
    end

    if Rails.env.development?
      @agreement.pdf1 = true
      @agreement.pdf2 = true
      @agreement.pdf3 = true
    end
  end

  def create
    @agreement = StudentAgreement.new(student_agreement_params)
    @agreement.user_id = current_user.id

    if @agreement.save
      redirect_to mypage_student_wizard_student_path
    else
      render :show
    end
  end

  def update
    @agreement = current_user.student_agreement

    if current_user.student.present? && current_user.student.status == Student::S_REJECTED
      @agreement.reapplied = true
    end

    if @agreement.update(student_agreement_params)
      redirect_to mypage_student_wizard_student_path
    else
      render :show
    end
  end

  private

  def student_agreement_params
    params.require(:student_agreement).permit(:user_id, :pdf1, :pdf2, :pdf3, :pdf4, :pdf5, :agreement)
  end
end