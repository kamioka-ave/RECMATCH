class CreatePickupProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :pickup_projects do |t|
      t.integer :project_id
      t.integer :rank, default: 0, null: false

      t.timestamps
    end

    add_column :sites, :project_id, :integer, after: :solicit_max

  end
end
