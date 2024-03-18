class Admin::Companies::ReviewDocumentsController < Admin::AdminController
  before_action :set_company
  before_action :set_review_document, only: [:destroy]

  def new
    @document = Company::ReviewDocument.new(company_id: @company.id)
  end

  def create
    @document = Company::ReviewDocument.new(review_document_params)
    @document.admin_id = current_admin.id

    unless @document.save
      render :new
    end
  end

  def destroy
    name = @document.name
    @document.destroy!
    redirect_to admin_company_path(@company), notice: "#{name}を削除しました"
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_review_document
    @document = Company::ReviewDocument.find(params[:id])
  end

  def review_document_params
    params.require(:company_review_document).permit(
      :company_id, :name, :file, :document_type, :status
    )
  end
end
