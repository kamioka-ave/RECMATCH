class ChangeSearchKeywordInVisits < ActiveRecord::Migration[5.1]
  def up
    change_column :visits, :search_keyword, :text
  end

  def down
    change_column :visits, :search_keyword, :string
  end
end
