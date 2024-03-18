class DropEducations < ActiveRecord::Migration[5.2]
  def change
    drop_table :educations
  end
end
