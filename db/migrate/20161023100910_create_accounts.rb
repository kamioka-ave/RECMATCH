class CreateAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.integer :depository, default: 0, null: false
      t.integer :credit, default: 0, null: false
      t.integer :balance, default: 0, null: false

      t.timestamps null: false
    end
  end
end
