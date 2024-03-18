class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.string :name
      t.string :email
      t.text :message
      t.string :file

      t.timestamps null: false
    end
  end
end
