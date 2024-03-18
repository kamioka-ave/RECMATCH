class Admin::Companies::ReviewsController < Admin::AdminController
  before_action :set_company
  before_action :set_review, only: [:edit, :update, :destroy]

  def new
    @review = CompanyReview.new(review_type: params[:review_type])
  end

  def edit
  end

  def create
    @review = CompanyReview.new(company_review_params)
    @review.company_id = @company.id
    @review.admin_id = current_admin.id
    @review.status = CompanyReview::AS_SUBMITTED

    if @review.save
      @reviews = CompanyReview.where(company_id: @company)
    else
      if @review.errors.key?(:file) && @review.errors[:file].size > 1
        @review.errors[:file].delete_at(0)
      end
      render :new
    end
  end

  def update
    @review.assign_attributes(company_review_params)
    @review.status = CompanyReview::AS_SUBMITTED

    if @review.save
      @reviews = CompanyReview.where(company_id: @company)
    else
      if @review.errors.key?(:file) && @review.errors[:file].size > 1
        @review.errors[:file].delete_at(0)
      end
      render :edit
    end
  end

  def destroy
    @review_type = @review.review_type
    @review.destroy
    @reviews = CompanyReview.where(company_id: @company)
    #CompanyReviewCompressJob.perform_later(@company.id)
  end

  def history
    @review_type = params[:review_type]
    @histories = CompanyReviewHistory.where(company_id: @company, review_type: @review_type).order(updated_at: :desc)
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
