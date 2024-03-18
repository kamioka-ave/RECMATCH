class Admin::Students::TransactionRecordsController < Admin::AdminController
  before_action :set_student

  def new
    @record = StudentTransactionRecord.new
  end

  def create
    @record = StudentTransactionRecord.new(student_transaction_record_params)
    @record.user_id = @student.user_id
    @record.student_id = @student.id

    if @record.order_id.present?
      order = NormalOrder.find(@record.order_id)
      if order.present? && @student.id == order.student_id
        @record.company_id = order.project.company_id
        @record.project_id = order.project_id
        @record.product_id = order.product_id
      end
    end

    if @record.save(context: :transaction_record)
      render :create
    else
      render :new
    end
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def student_transaction_record_params
    params.require(:student_transaction_record).permit(
      :transaction_type, :transaction_at, :depository, :credit, :order_id
    )
  end
end
