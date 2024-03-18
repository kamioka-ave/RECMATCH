class Projects::ApplicantsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_project

  def new
    if request.xhr?
      @applicant = Project::Applicant.new

      if user_signed_in? && current_user.can_invest?
        @student = current_user.student
      else
        render :sign_in
      end
    else
      render_404
    end
  end

  def create
    @applicant = Project::Applicant.new(applicant_params)

    unless @applicant.save
      render :new
    end
  end

  def destroy
    @applicant = Project::Applicant.find(params[:id])
    @applicant.destroy!
  end

  def submit
    @applicant = Project::Applicant.new
    @applicant.project_id = params[:id]
    @applicant.student_id = current_user.student.id
    unless @applicant.save
      redirect_to project_path(params[:id]), notice: '登録に失敗しました。お時間をおいて再度お試しください'
    else
      CompanyMailer.offer_from_student(@applicant).deliver_later
      render :submit
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def applicant_params
    params.require(:project_applicant).permit(:project_id, :student_id)
  end
end
