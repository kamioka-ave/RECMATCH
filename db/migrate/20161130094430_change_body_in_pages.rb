class ChangeBodyInPages < ActiveRecord::Migration[4.2]
  def up
    change_column :pages, :body, :text, limit: 0xffffff
    change_column :page_drafts, :body, :text, limit: 0xffffff
  end

  def down
    change_column :pages, :body, :text, limit: 0xffff
    change_column :page_drafts, :body, :text, limit: 0xffff
  end
end
