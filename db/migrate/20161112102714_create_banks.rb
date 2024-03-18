class CreateBanks < ActiveRecord::Migration[4.2]
  def change
    create_table :banks do |t|
      t.string :name
      t.string :kana
      t.boolean :is_popular, null: false, default: false

      t.timestamps null: false
    end
  end
end
