class CreateCompanyReviewHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :company_review_histories do |t|
      t.integer :company_review_id
      t.integer :company_id
      t.integer :admin_id
      t.integer :review_type
      t.string :file
      t.integer :authorizer
      t.integer :status

      t.timestamps null: false
    end
  end
end
