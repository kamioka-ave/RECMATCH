class Admin::Companies::BalanceSheetsController < Admin::AdminController
  before_action :set_company
  before_action :set_balance_sheet, only: [:edit, :update, :destroy]

  def index
    @balance_sheets = CompanyBalanceSheet.all.order(:date => :desc)
  end

  def new
    @balance_sheet = CompanyBalanceSheet.new

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name, admin_company_path(@company)
    add_breadcrumb 'バランスシートの登録'
  end

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name, admin_company_path(@company)
    add_breadcrumb 'バランスシートの編集'
  end

  def create
    @balance_sheet = CompanyBalanceSheet.new(company_balance_sheet_params)
    @balance_sheet.company_id = @company.id

    if @balance_sheet.save
      redirect_to admin_company_path(@company), notice: 'バランスシートを登録しました'
    else
      @balance_sheet.file.cache! if @balance_sheet.file.present?
      add_breadcrumb 'ダッシュボード', admin_root_path
      add_breadcrumb '企業一覧', admin_companies_path
      add_breadcrumb @company.name, admin_company_path(@company)
      add_breadcrumb 'バランスシートの登録'
      render :new
    end
  end

  def update
    if @balance_sheet.update(company_balance_sheet_params)
      redirect_to admin_company_path(@company), notice: 'バランスシートを更新しました'
    else
      @balance_sheet.file.cache! if @balance_sheet.file.present?
      add_breadcrumb 'ダッシュボード', admin_root_path
      add_breadcrumb '企業一覧', admin_companies_path
      add_breadcrumb @company.name, admin_company_path(@company)
      add_breadcrumb 'バランスシートの編集'
      render :edit
    end
  end

  def destroy
    @balance_sheet.destroy
    redirect_to admin_company_path(@company), notice: 'バランスシートを削除しました'
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_balance_sheet
    @balance_sheet = CompanyBalanceSheet.find(params[:id])
  end

  def company_balance_sheet_params
    params.require(:company_balance_sheet).permit(:name, :file, :file_cache, :date)
  end
end