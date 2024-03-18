class AddImageToHeadlines < ActiveRecord::Migration[4.2]
  def up
    add_column :headlines, :image, :string
  end

  def down
    remove_column :headlines, :image
  end
end
