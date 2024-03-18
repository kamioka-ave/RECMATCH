class AddOperationToCompanyReviewHistories < ActiveRecord::Migration[5.0]
  def change
    add_column :company_review_histories, :operation, :integer, default: 0, null: false
  end
end
