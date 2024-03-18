class MigrateCreateRoleStaff < ActiveRecord::Migration[5.2]
  def change
    Role.find_or_initialize_by(name: "staff").save!
  end
end
