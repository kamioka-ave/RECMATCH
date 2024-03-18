class Api::V1::BanksController < Api::V1::ApiController
  def index
    @banks = Bank.all
  end
end