class DropAffiliates < ActiveRecord::Migration[5.0]
  def change
    drop_table :affiliates
    drop_table :refferrals
  end
end
