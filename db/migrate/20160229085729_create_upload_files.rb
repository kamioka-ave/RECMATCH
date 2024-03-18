class CreateUploadFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :upload_files do |t|
      t.integer :uploadable_id
      t.string :uploadable_type
      t.string :name

      t.timestamps null: false
    end
  end
end
