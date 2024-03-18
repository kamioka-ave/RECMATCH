class CreateProjectMeets < ActiveRecord::Migration[5.2]
  def change
    create_table :project_meets do |t|
      t.integer :project_id
      t.integer :project_offer_id
      t.integer :project_applicant_id
      t.integer :company_id
      t.integer :student_id
      t.datetime :start
      t.datetime :end
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
