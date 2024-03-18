class CreateProjectCorrectedDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :project_corrected_documents do |t|
      t.integer :project_id
      t.string :name
      t.string :file

      t.timestamps
    end
  end
end
