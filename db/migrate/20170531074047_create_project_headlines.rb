class CreateProjectHeadlines < ActiveRecord::Migration[5.0]
  def change
    create_table :project_headlines do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :admin_id
      t.string :name
      t.text :body

      t.timestamps
    end
  end
end
