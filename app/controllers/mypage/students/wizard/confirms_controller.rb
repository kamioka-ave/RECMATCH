class Mypage::Students::Wizard::ConfirmsController < Mypage::Students::Wizard::BaseController
  def show
    @student = current_user.student
    #@interview = current_user.student_interview
    #@identification = current_user.identification
    #@pep = current_user.student.pep
  end

  def update
    @student = current_user.student

    if current_user.confirmed_at.nil?
      return redirect_back(fallback_location: mypage_root_path)
    end

    if @student.status == Student::S_REJECTED
      @student.reapply_confirmation = params[:student][:reapply_confirmation] == '1'
      # @student.assign_attributes(student_params)
    end

    @student.apply!
    redirect_to thanks_mypage_student_wizard_page_path
  rescue
    render :show
  end

  # private
  #
  # def student_params
  #   params.require(:student).permit(:reapply_confirmation)
  # end
end