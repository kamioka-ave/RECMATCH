class Events::ApplicantsController < ApplicationController
  before_action :set_event

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
    @applicant = EventApplicant.new
    @applicant.event_id = params[:id]
    @applicant.student_id = current_user.student.id
    @check_uniq = EventApplicant.where('event_id = ? AND student_id = ?', @applicant.event_id, @applicant.student_id)
    unless @check_uniq.blank? && @applicant.save
      redirect_to event_path(params[:id]), notice: '登録に失敗しました。お時間をおいて再度お試しください'
    else
      CompanyMailer.event_applicant(@applicant).deliver_later
      render :submit
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def applicant_params
    params.require(:event_applicant).permit(:project_id, :student_id)
  end
end
