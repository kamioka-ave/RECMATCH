class Admin::Students::AccountsController < Admin::AdminController
  before_action :set_student

  def create
    @account = AccountTerm.new(account_term_params)
    @student_transactions = StudentTransactionRecord.includes(order: [project: :company])
                                 .where(student_id: @student.id, transaction_at: (@account.start_at)..(@account.end_at.tomorrow - 1.second))
                                 .order(:transaction_at, :id)
    render(StudentAccount.new.render_params.merge(pdf: 'student_account'))
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def account_term_params
    params.require(:account_term).permit(:start_at, :end_at)
  end
end
