class CreateCompanyReviews < ActiveRecord::Migration[4.2]
  def change
    create_table :company_reviews do |t|
      t.integer :company_id
      t.integer :admin_id
      t.integer :review_type
      t.string :file
      t.integer :authorizer
      t.integer :status, default: 0, null: false

      t.timestamps null: false
    end
  end
end
