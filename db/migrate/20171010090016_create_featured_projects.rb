class CreateFeaturedProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :featured_projects do |t|
      t.integer :project_id
      t.integer :rank, default: 0, null: false
      t.string :image

      t.timestamps
    end
  end
end
