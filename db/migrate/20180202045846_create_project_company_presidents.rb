class CreateProjectCompanyPresidents < ActiveRecord::Migration[5.1]
  def change
    create_table :project_company_presidents do |t|
      t.integer :projectable_id
      t.string :projectable_type
      t.string :position
      t.string :first_name
      t.string :first_name_kana
      t.string :last_name
      t.string :last_name_kana

      t.timestamps
    end

    add_index :project_company_presidents, [:projectable_id, :projectable_type], name: 'index_project_company_presidents_on_id_and_type'
  end
end
