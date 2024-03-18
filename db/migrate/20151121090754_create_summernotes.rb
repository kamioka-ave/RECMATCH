class CreateSummernotes < ActiveRecord::Migration[4.2]
  def change
    create_table :summernotes do |t|
      t.integer :admin_id
      t.string :image

      t.timestamps null: false
    end
  end
end
