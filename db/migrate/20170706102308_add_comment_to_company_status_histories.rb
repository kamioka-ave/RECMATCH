class AddCommentToCompanyStatusHistories < ActiveRecord::Migration[5.0]
  def change
    add_column :company_status_histories, :comment, :text, after: :is_antisocial_check_passed
  end
end
