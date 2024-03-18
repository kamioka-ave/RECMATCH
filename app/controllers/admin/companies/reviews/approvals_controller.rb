class Admin::Companies::Reviews::ApprovalsController < Admin::AdminController
  before_action :set_company, :set_review

  def edit; end

  def update
    @review.assign_attributes(company_review_params)
    @review.authorizer_id = current_admin.id

    if params[:reject]
      unless @review.valid?(:reject)
        render :edit
        return
      end

      CompanyMailer.review_rejected(@company, @review, company_review_params[:comment]).deliver_later
      @review.status = CompanyReview::AS_REJECTED
    else
      @review.status = CompanyReview::AS_APPROVED
    end

    @review.save!
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_review
    @review = CompanyReview.find(params[:review_id])
  end

  def company_review_params
    params.require(:company_review).permit(:status, :comment)
  end
end