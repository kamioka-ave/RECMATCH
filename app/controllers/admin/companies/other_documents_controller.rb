class Admin::Companies::OtherDocumentsController < Admin::AdminController
  before_action :set_company
  before_action :set_other_document, only: [:destroy]

  def new
    @document = Company::OtherDocument.new(company_id: @company.id)
  end

  def create
    @document = Company::OtherDocument.new(other_document_params)
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

  def set_other_document
    @document = Company::OtherDocument.find(params[:id])
  end

  def other_document_params
    params.require(:company_other_document).permit(
      :company_id, :name, :file, :description
    )
  end
end
