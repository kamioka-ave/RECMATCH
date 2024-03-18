class ChangeAuthorizerInCompanyReviews < ActiveRecord::Migration[4.2]
  def change
    rename_column :company_reviews, :authorizer, :authorizer_id
    rename_column :company_review_histories, :authorizer, :authorizer_id
  end
end
