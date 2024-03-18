class CreateCompanyFollowers < ActiveRecord::Migration[5.1]
  def change
    create_table :company_followers do |t|
      t.integer :company_id
      t.integer :user_id
      t.integer :student_id
      t.string :email

      t.timestamps
    end

  end
end
