# frozen_string_literal: true

class Admin::Companies::FaresController < Admin::AdminController
  before_action :set_company
  before_action :set_fare, only: [:edit, :update, :destroy]

  def new
    @fare = Company::Fare.new(company_id: @company.id)
  end

  def create
    @fare = Company::Fare.new(fare_params)
    @fare.admin_id = current_admin.id
    @fare.company_id = @company.id
    unless @fare.save
      render :new
    end
  end

  def edit; end

  def update
    unless @fare.update(fare_params)
      render :edit
    end
  end

  def destroy
    @fare.destroy!
    redirect_to admin_company_path(@company), notice: 'システム利用料請求を削除しました'
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_fare
    @fare = Company::Fare.find_by!(id: params[:id], company_id: @company)
  end

  def fare_params
    params.require(:company_fare).permit(
      :company_id, :priority_no, :start_at, :save_end_at, :end_at, :price, :subject, :subject_note
    )
  end
end
