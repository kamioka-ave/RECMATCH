class CreatePayments < ActiveRecord::Migration[4.2]
  def change
    create_table :payments do |t|
      t.string :name
      t.integer :charge

      t.timestamps null: false
    end
  end
end
