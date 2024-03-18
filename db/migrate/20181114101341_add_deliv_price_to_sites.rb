class AddDelivPriceToSites < ActiveRecord::Migration[5.2]
  def up
    remove_column :sites, :solicit_max
    add_column :sites, :execution_price, :integer, after: :project_id
    add_column :sites, :fastest_second, :integer, after: :execution_price
    add_column :sites, :fastest_price, :integer, after: :fastest_second

    site = Site.find_by(id: 1)
    if site != nil
      site.refresh_props!
    end
  end

  def down
    add_column :sites, :solicit_max, :integer, limit: 8, default: 100_000_000, after: :id
    remove_column :sites, :execution_price
    remove_column :sites, :fastest_second
    remove_column :sites, :fastest_price
  end
end
