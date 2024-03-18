class Api::V1::BankBranchesController < Api::V1::ApiController
  def index
    @bank_branches = BankBranch.where(bank_id: params[:bank_id])
  end
end