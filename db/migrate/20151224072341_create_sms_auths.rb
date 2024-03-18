class CreateSmsAuths < ActiveRecord::Migration[4.2]
  def change
    create_table :sms_auths do |t|
      t.integer :user_id
      t.string :tel
      t.string :token
      t.boolean :authorized

      t.timestamps null: false
    end

    add_index :sms_auths, :tel, unique: true
  end
end
