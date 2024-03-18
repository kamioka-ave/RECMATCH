class CreateOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :student_id
      t.integer :project_id
      t.integer :payment_id
      t.datetime :contact_date
      t.integer :status

      t.timestamps null: false
    end
  end
end
