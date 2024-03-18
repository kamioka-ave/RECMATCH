class AddHiraganaToBanks < ActiveRecord::Migration[4.2]
  def change
    add_column :banks, :hiragana, :string, after: :kana
    add_column :bank_branches, :hiragana, :string, after: :kana
  end
end
