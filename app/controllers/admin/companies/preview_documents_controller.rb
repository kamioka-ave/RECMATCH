class Admin::Companies::PreviewDocumentsController < Admin::AdminController
  before_action :set_company
  before_action :set_preview_document, only: [:destroy]

  def new
    @document = Company::PreviewDocument.new(company_id: @company.id)
  end

  def create
    @document = Company::PreviewDocument.new(preview_document_params)
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

  def set_preview_document
    @document = Company::PreviewDocument.find(params[:id])
  end

  def preview_document_params
    params.require(:company_preview_document).permit(
      :company_id, :name, :file, :document_type
    )
  end
end
