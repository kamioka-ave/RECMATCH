class AddColumnSupporters < ActiveRecord::Migration[5.2]
  def change
    add_column :supporters, :can_view_project, :boolean, default: false, after: :company_supporter_messages_count
  end
end
