class Admin::Students::PepsController < Admin::AdminController
  before_action :set_pep

  def edit; end

  def update
    if @pep.update(pep_params)
      render :update
    else
      render :edit
    end
  end

  def document
    render(
      pdf: 'pep_document',
      orientation: 'Portrait',
      page_size: 'A4',
      encoding: 'UTF-8'
    )
  end

  private

  def set_pep
    @student = Student.find(params[:student_id])
    @pep = @student.pep
  end

  def pep_params
    params.require(:student_pep).permit(:received_at, :receiver_id, :approver_id)
  end
end
