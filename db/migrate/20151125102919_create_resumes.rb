class CreateResumes < ActiveRecord::Migration[4.2]
  def change
    create_table :resumes do |t|
      t.integer :user_id
      t.string :company
      t.string :office
      t.date :started_on
      t.date :finished_on
      t.boolean :is_working
      t.text :note

      t.timestamps null: false
    end
  end
end
