class RemovePdf6FromStudentAgreements < ActiveRecord::Migration[4.2]
  def change
    remove_column :student_agreements, :pdf6, :boolean
  end
end
