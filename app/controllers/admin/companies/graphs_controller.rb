class Admin::Companies::GraphsController < Admin::AdminController
  before_action :set_company
  before_action :set_graph, only: [:show, :edit, :update, :destroy]

  def index
    @graphs = CompanyGraph.all.order(:created_at => :desc)
  end

  def show
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name, admin_company_path(@company)
    add_breadcrumb "#{@graph.name}データの編集"
  end

  def new
    @graph = CompanyGraph.new

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name, admin_company_path(@company)
    add_breadcrumb 'グラフの登録'
  end

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name, admin_company_path(@company)
    add_breadcrumb 'グラフの編集'
  end

  def create
    @graph = CompanyGraph.new(company_graph_params)
    @graph.company_id = @company.id

    if @graph.save
      redirect_to admin_company_path(@company), notice: 'グラフを登録しました'
    else
      add_breadcrumb 'ダッシュボード', admin_root_path
      add_breadcrumb '企業一覧', admin_companies_path
      add_breadcrumb @company.name, admin_company_path(@company)
      add_breadcrumb 'グラフの登録'
      render :new
    end
  end

  def update
    if @graph.update(company_graph_params)
      redirect_to admin_company_path(@company), notice: 'グラフを更新しました'
    else
      @graph.file.cache! if @graph.file.present?
      add_breadcrumb 'ダッシュボード', admin_root_path
      add_breadcrumb '企業一覧', admin_companies_path
      add_breadcrumb @company.name, admin_company_path(@company)
      add_breadcrumb 'グラフの編集'
      render :edit
    end
  end

  def destroy
    @graph.destroy
    redirect_to admin_company_path(@company), notice: 'グラフを削除しました'
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_graph
    @graph = CompanyGraph.find(params[:id])
  end

  def company_graph_params
    params.require(:company_graph).permit(:name, :rank)
  end
end