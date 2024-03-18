class CreateQuitQuitReasons < ActiveRecord::Migration[5.0]
  def change
    create_table :quit_quit_reasons do |t|
      t.integer :quit_id
      t.integer :quit_reason_id

      t.timestamps
    end
  end
end
