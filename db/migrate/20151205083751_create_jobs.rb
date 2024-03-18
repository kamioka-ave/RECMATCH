class CreateJobs < ActiveRecord::Migration[4.2]
  def change
    create_table :jobs do |t|
      t.integer :project_id
      t.string :title
      t.text :description
      t.integer :job_type
      t.date :close_on

      t.timestamps null: false
    end
  end
end
