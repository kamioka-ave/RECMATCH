class AddRejectReasonToCompanies < ActiveRecord::Migration[5.0]
  def change
    rename_column :company_status_histories, :comment, :reject_reason
  end
end
