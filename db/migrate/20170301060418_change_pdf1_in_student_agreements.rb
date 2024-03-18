class ChangePdf1InStudentAgreements < ActiveRecord::Migration[5.0]
  def change
    change_column :student_agreements, :pdf1, :boolean, default: false
  end
end
