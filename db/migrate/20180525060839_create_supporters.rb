class CreateSupporters < ActiveRecord::Migration[5.1]
  def change
    create_table :supporters do |t|
      t.integer :user_id
      t.string :first_name
      t.string :first_name_kana
      t.string :last_name
      t.string :last_name_kana
      t.string :office

      t.timestamps
    end
  end
end
