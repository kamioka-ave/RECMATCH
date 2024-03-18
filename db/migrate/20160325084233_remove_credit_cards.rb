class RemoveCreditCards < ActiveRecord::Migration[4.2]
  def up
    drop_table :credit_cards
    remove_column :orders, :credit_card_id
    change_column_default :orders, :status, 0
  end

  def down
    create_table :credit_cards do |t|
      t.integer :user_id
      t.string :number
      t.string :verification_value
      t.integer :year
      t.integer :month
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end

    add_column :orders, :credit_card_id, :integer
  end
end
