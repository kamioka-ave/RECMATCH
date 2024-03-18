class AddCodeJaToCountries < ActiveRecord::Migration[5.0]
  def change
    add_column :countries, :code_ja, :string, after: :code
  end
end
