class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :company_id
      t.integer :proposal_id
      t.string :title
      t.string :name
      t.string :image
      t.integer :event_type
      t.datetime :start
      t.datetime :end
      t.mediumtext :description
      t.integer :capacity
      t.integer :prefecture_id
      t.string :address
      t.integer :status
      t.boolean :selection
      t.integer :revision, null: false, default: 1

      t.timestamps
    end
  end
end
