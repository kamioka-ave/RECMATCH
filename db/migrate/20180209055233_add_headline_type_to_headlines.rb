class AddHeadlineTypeToHeadlines < ActiveRecord::Migration[5.1]
  def change
    add_column :headlines, :headline_type, :integer, default: 0, null: false, after: :id
    remove_column :headlines, :admin
    remove_column :headlines, :image
  end
end
