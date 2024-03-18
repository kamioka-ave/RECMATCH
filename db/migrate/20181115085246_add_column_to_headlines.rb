class AddColumnToHeadlines < ActiveRecord::Migration[5.2]
  def change
    add_column :headlines, :status, :integer, after: :body, default: 0
  end
end
