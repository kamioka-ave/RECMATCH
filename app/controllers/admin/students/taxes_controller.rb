class Admin::Students::TaxesController < Admin::AdminController
  before_action :set_student

  def edit; end

  def update
    unless student_params.has_key?(:tax_payment_receipt) && @student.update(student_params)
      @student.errors.add(:tax_payment_receipt, 'を選択してください')
      render :edit
    end
  end

  def approve
    if @student.update(student_params)
      StudentMailer.tax_approved(@student).deliver_later
      redirect_to admin_student_path(@student), notice: '納税書を確認済みにしました'
    else
      render file: 'admin/students/show'
    end
  end

  def reject_form; end

  def reject
    unless student_params.has_key?(:comment) && student_params[:comment] != '' && @student.update(student_params)
      @student.errors.add(:comment, 'を入力してください')
      render :reject_form
    else
      StudentMailer.tax_rejected(@student, student_params[:comment]).deliver_later
    end
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def student_params
    params.require(:student).permit(:tax_payment_receipt, :tax_payment_receipt_status, :comment)
  end
end