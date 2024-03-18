class CreatePublicMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :public_messages do |t|
      t.integer :admin_id
      t.datetime :answer_time
      t.integer :status, null: false, default: 0
      t.text :answer
      t.string :name
      t.string :email
      t.string :phone
      t.text :description

      t.timestamps
    end
  end
end
