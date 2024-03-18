class Admin::Companies::ReviewDocuments::ApprovalsController < Admin::AdminController
  before_action :set_company, :set_review_document

  def edit; end

  def update
    @document.assign_attributes(review_document_params)
    @document.authorizer_id = current_admin.id

    if params[:reject]
      unless @document.valid?(:reject)
        render :edit
        return
      end

      CompanyMailer.review_document_rejected(@company, @document, review_document_params[:comment]).deliver_later
      @document.status = Company::ReviewDocument::AS_REJECTED
    else
      @document.status = Company::ReviewDocument::AS_APPROVED
    end

    @document.save!
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_review_document
    @document = Company::ReviewDocument.find(params[:review_document_id])
  end

  def review_document_params
    params.require(:company_review_document).permit(:status, :comment)
  end
end