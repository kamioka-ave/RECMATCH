class Admin::TransactionsController < Admin::AdminController
  def students
    @q = StudentTransactionRecord.ransack(params[:q])
    @student_transactions = @q.result.page(params[:page]).per(100)
  end

  def companies
    @q = CompanyTransactionRecord.ransack(params[:q])
    @company_transactions = @q.result.page(params[:page]).per(100)
  end
end
