class CreateQuits < ActiveRecord::Migration[5.0]
  def change
    create_table :quits do |t|
      t.integer :user_id
      t.text :note

      t.timestamps
    end
  end
end
