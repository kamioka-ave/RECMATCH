class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :userid
      t.integer :company_id
      t.integer :student_id
      t.datetime :sent_at
      t.text :subject
      t.text :content

      t.timestamps
    end
  end
end
