class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :name_en
      t.string :code
      t.string :code_string2
      t.string :code_string3

      t.timestamps
    end
  end
end
