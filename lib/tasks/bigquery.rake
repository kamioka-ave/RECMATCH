require 'google/cloud/bigquery'

namespace :bigquery do
  task sync_users: :environment do
    client = BigqueryUser.new
    client.sync
  end

  task sync_students: :environment do
    client = BigqueryStudent.new
    client.sync
  end

  task sync_inbounds: :environment do
    client = BigqueryInbound.new
    client.sync
  end

  task sync_projects: :environment do
    client = BigqueryProject.new
    client.sync
  end

  task sync_orders: :environment do
    client = BigqueryOrder.new
    client.sync
  end

  task sync_events: :environment do
    client = BigqueryEvent.new
    client.sync
  end

  task sync_all: :environment do
    client = BigqueryUser.new
    client.sync
    client = BigqueryStudent.new
    client.sync
    client = BigqueryInbound.new
    client.sync
    client = BigqueryProject.new
    client.sync
    client = BigqueryOrder.new
    client.sync
    client = BigqueryEvent.new
    client.sync
  end

  task test: :environment do
    order = Order.find(18)
    client = BigqueryOrder.new
    client.insert(order)
  end
end
