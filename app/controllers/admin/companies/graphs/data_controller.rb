class Admin::Companies::Graphs::DataController < Admin::AdminController
  before_action :set_company, :set_graph
  before_action :set_datum, only: [:edit, :update, :destroy]

  def new
    @datum = CompanyGraphDatum.new
    @title = 'データを登録'
  end

  def edit
    @title = 'データを編集'
  end

  def create
    @datum = CompanyGraphDatum.new(company_graph_datum_params)
    @datum.company_graph_id = @graph.id

    if @datum.save
      render :create
    else
      @title = 'データを登録'
      render :new
    end
  end

  def update
    if @datum.update(company_graph_datum_params)
      render :update
    else
      @title = 'データを編集'
      render :edit
    end
  end

  def destroy
    @datum.destroy!
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_graph
    @graph = CompanyGraph.find(params[:graph_id])
  end

  def set_datum
    @datum = CompanyGraphDatum.find(params[:id])
  end

  def company_graph_datum_params
    params.require(:company_graph_datum).permit(:label, :data)
  end
end