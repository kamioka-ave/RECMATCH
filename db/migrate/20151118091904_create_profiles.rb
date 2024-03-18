class CreateProfiles < ActiveRecord::Migration[4.2]
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :image
      t.string :name_kana
      t.string :company
      t.string :tel
      t.integer :gender, default: 0, null: false
      t.string :zip_code
      t.string :identification
      t.text :identification_note
      t.boolean :identified, default: false, null: false

      t.timestamps null: false
    end
  end
end
