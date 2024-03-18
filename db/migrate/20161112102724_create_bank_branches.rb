class CreateBankBranches < ActiveRecord::Migration[4.2]
  def change
    create_table :bank_branches do |t|
      t.integer :bank_id
      t.integer :code
      t.string :name
      t.string :kana

      t.timestamps null: false
    end
  end
end
