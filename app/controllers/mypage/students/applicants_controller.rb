class Mypage::Students::ApplicantsController < Mypage::MypageController
  before_action :set_student
  before_action :set_report, only: [:destroy, :edit, :update]
  before_action :applicant_params, only: [:create, :update]
  layout 'mypage_student'

  def index
    @applicants = Student::Applicant.where(student_id: @student.id)
    @applicant = Student::Applicant.find_by(student_id: @student.id)
  end

  def new
    @applicant = Student::Applicant.new
    render :form
  end

  def create
    @applicant = Student::Applicant.new(applicant_params)
    @applicant.student_id = @student.id
    if @applicant.save
      redirect_to mypage_student_applicants_path, notice: '面談を予約しました'
    else
      render :form
    end
  end

  def edit
    render :form
  end

  def update
    if @applicant.update(applicant_params)
      redirect_to mypage_student_applicants_path, notice: '面談予約を変更しました'
    else
      render :form
    end
  end

  def destroy
    @applicant.destroy!
    redirect_to mypage_student_applicants_path, notice: '面談予約を削除しました'
  end

  private

  def applicant_params
      params.require(:student_applicant).permit(
        :status, :book1_at, :book2_at, :book3_at, :meet_type
      )
  end

  def set_report
    @applicant = Student::Applicant.find(params[:id])
  end

  def set_student
    @student = current_user.student
  end
end