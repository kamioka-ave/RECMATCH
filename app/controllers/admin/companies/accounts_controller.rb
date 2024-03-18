class Admin::Companies::AccountsController < Admin::AdminController
  before_action :set_company

  def create
    @account_term = AccountTerm.new(account_term_params)
    @company_transactions = CompanyTransactionRecord.includes(:company, :project)
                                .where(company_id: @company.id, transaction_at: (@account_term.start_at)..(@account_term.end_at + 1.day))
                                .order(:transaction_at, :id)
    render(
      pdf: 'company_account',
      template: 'admin/companies/accounts/show_body',
      orientation: 'Landscape',
      page_size: 'A4',
      encoding: 'UTF-8',
      viewport_size: '800x600',
      dpi: 96,
      margin: {
        top: 40,
        bottom: 78
      },
      header:  {
        spacing: 1,
        html: {
          template: 'admin/companies/accounts/show_header'
        }
      },
      footer: {
        spacing: 1,
        html: {
          template: 'admin/companies/accounts/show_footer'
        }
      }
    )
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def account_term_params
    params.require(:account_term).permit(:start_at, :end_at)
  end
end
