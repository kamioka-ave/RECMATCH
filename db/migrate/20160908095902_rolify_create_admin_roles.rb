class RolifyCreateAdminRoles < ActiveRecord::Migration[4.2]
  def change
    create_table(:admin_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:admins_admin_roles, :id => false) do |t|
      t.references :admin
      t.references :admin_role
    end

    add_index(:admin_roles, :name)
    add_index(:admin_roles, [ :name, :resource_type, :resource_id ])
    add_index(:admins_admin_roles, [ :admin_id, :admin_role_id ])

    # AdminRole.create(name: 'admin')
    # admin = Admin.new(name: 'Kohei', email: 'skam123+admin@gmail.com', password: 'Ps2Y9j4G', password_confirmation: 'Ps2Y9j4G', role_ids: ['1'])
    # admin.skip_confirmation!
    # admin.save
    # Admin::StudentsDisplay.create!(admin_id: admin.id)
  end
end
