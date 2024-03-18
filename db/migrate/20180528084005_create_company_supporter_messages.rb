class CreateCompanySupporterMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :company_supporter_messages do |t|
      t.integer :company_supporter_id
      t.integer :sender_id
      t.string :sender_type
      t.integer :receiver_id
      t.string :receiver_type
      t.text :body, collation: "utf8mb4_unicode_ci"
      t.string :attachment
      t.boolean :read, default: false, null: false

      t.timestamps
    end

    add_column :supporters, :company_supporter_messages_count, :integer, default: 0, null: false, after: :office
  end
end
