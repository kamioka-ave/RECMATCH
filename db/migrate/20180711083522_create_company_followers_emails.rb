class CreateCompanyFollowersEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :company_followers_emails do |t|
      t.integer :company_id
      t.integer :admin_id
      t.integer :job_id
      t.string :subject
      t.text :plain
      t.text :rich
      t.integer :status

      t.timestamps
    end
  end
end
