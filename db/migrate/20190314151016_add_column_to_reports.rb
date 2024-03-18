class AddColumnToReports < ActiveRecord::Migration[5.2]
  def up
    add_column :reports, :report_type_name, :string, after: :report_type
  end

  def down
    remove_column :reports, :report_type_name
  end
end
