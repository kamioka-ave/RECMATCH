class CreateProjectContractImages < ActiveRecord::Migration[5.1]
  def change
    create_table :project_contract_images do |t|
      t.integer :projectable_id
      t.string :projectable_type
      t.string :image

      t.timestamps
    end

    add_index :project_contract_images, [:projectable_id, :projectable_type], name: 'index_project_contract_images_on_id_and_type'
  end
end
