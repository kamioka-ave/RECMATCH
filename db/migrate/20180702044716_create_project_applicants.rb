class CreateProjectApplicants < ActiveRecord::Migration[5.1]
  def change
    create_table :project_applicants do |t|
      t.integer :project_id
      t.integer :student_id
      t.integer :status, default: 0, null: false
      t.datetime :start
      t.datetime :end

      t.timestamps
    end

    add_column :projects, :applicants_count, :integer, default: 0, null: false
  end
end
