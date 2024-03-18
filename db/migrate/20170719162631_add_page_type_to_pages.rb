class AddPageTypeToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :page_drafts, :page_type, :integer, default: 0, null: false, after: :path
    add_column :page_drafts, :head, :text, after: :title
    add_column :pages, :page_type, :integer, default: 0, null: false, after: :path
    add_column :pages, :head, :text, after: :title
  end
end
