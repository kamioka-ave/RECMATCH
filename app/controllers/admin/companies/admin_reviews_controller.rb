class Admin::Companies::AdminReviewsController < Admin::AdminController
  before_action :set_company
  before_action :set_review, only: [:destroy]

  def new
    @review = CompanyReview.new(review_type: params[:review_type])
  end

  def create
    @review = CompanyReview.new(company_review_params)
    @review.company_id = @company.id
    @review.admin_id = current_admin.id
    @review.status = CompanyReview::AS_APPROVED

    if @review.save
      @reviews = CompanyReview.where(company_id: @company)
    else
      if @review.errors.key?(:file) && @review.errors[:file].size > 1
        @review.errors[:file].delete_at(0)
      end
      render :new
    end
  end

  def destroy
    @review_type = @review.review_type
    @review.destroy
    @reviews = CompanyReview.where(company_id: @company)
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_review
    @review = CompanyReview.find(params[:id])
  end

  def company_review_params
    params.require(:company_review).permit(:review_type, :file)
  end
end
