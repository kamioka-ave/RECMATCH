class CreateCompanies < ActiveRecord::Migration[4.2]
  def change
    create_table :companies do |t|
      t.integer :user_id
      t.integer :creator_id
      t.integer :issuer_id
      t.integer :business_type_id
      t.string  :name
      t.string  :name_kana
      t.string  :president_first_name
      t.string  :president_first_name_kana
      t.string  :president_last_name
      t.string  :president_last_name_kana
      t.date  :president_birth_on
      t.string  :zip_code
      t.integer :prefecture_id
      t.string  :city
      t.string  :address1
      t.string  :address2
      t.string  :phone
      t.datetime  :created_at
      t.datetime  :updated_at
      t.datetime  :deleted_at
      t.integer :market_cap
      t.integer :stage
      t.integer :capital
      t.integer :sales_profit
      t.date  :birth_on
      t.date  :accounting_started_on
      t.date  :accounting_finished_on
      t.string  :website
      t.string  :image
      t.integer :draft_id
      t.timestamp :published_at
      t.timestamp :trashed_at
      t.string  :image_draft
      t.string  :reviews_zip
      t.string  :angels_zip
      t.text  :business_summary
      t.text  :business_philosophy
      t.text  :hope
      t.text  :business_shebang
      t.text  :main_shareholders
      t.text  :financing
      t.text  :introduce_something
      t.integer :status
      t.text  :reject_reason
      t.integer :employees
      t.integer :this_year_employments
      t.integer :last_year_employments
      t.boolean :this_year_employments_reveal
      t.boolean :last_year_employments_reveal
      t.text  :competitive_strength
      t.text  :competitive_difference
      t.text  :target
      t.text  :ceo_hopes
      t.datetime  :applied_at
      t.boolean :is_identification_passed
      t.datetime  :identified_at
      t.integer :identifier_id
      t.boolean :is_antisocial_check_passed
      t.datetime  :antisocial_checked_at
      t.integer :antisocial_checker_id
      t.integer :approver_id
      t.boolean :agree_with_clause
      t.boolean :agree_with_pre_judge
      t.datetime  :agree_with_pre_judge_at
      t.integer :company_supporter_messages_count
      t.boolean :primary_sales_support_completed
      t.boolean :all_sales_support_completed
      t.integer :followers_count
      t.integer :chat_toggle
      t.boolean :agree_use_group_chat
      t.integer :company_supporter_messages_count, :default => 0

      t.timestamps null: false
    end
  end
end
