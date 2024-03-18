class AddDeletedAtToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :deleted_at, :datetime
    add_index :consultations, :deleted_at
  end
end
