class AddCommentToCompanyReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :company_reviews, :comment, :text, after: :file
    add_column :company_review_histories, :comment, :text, after: :file
  end
end
