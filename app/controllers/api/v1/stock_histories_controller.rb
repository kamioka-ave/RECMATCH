class Api::V1::StockHistoriesController < Api::V1::ApiController
  before_action :authenticate_user!

  def index
    student = current_user.student
    statistics = if params[:company_id].present?
      student.calculate_assets(company_ids: [params[:company_id].to_i])
    else
      student.calculate_assets
    end
    render json: statistics.to_json, status: 200
  end
end
