class CreateProjectTerms < ActiveRecord::Migration[5.1]
  def change
    create_table :project_terms do |t|
      t.integer :project_id
      t.datetime :finish_at

      t.timestamps
    end
  end
end
