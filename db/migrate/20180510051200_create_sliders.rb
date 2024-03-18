class CreateSliders < ActiveRecord::Migration[5.1]
  def change
    create_table :sliders do |t|
      t.string :slider_type
      t.integer :project_id
      t.integer :event_id
      t.integer :headline_id
      t.integer :rank, default: 0, null: false
      t.string :image
      t.string :bg_image

      t.timestamps
    end
  end
end
