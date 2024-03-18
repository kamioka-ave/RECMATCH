class Ahoy::Event < ActiveRecord::Base
#  include Ahoy::Properties
#
#  self.table_name = 'ahoy_events'
#
#  belongs_to :visit
#  belongs_to :user, optional: true

#  serialize :properties, JSON

#  after_create_commit do
#    AddBigqueryEventJob.perform_later(id)
#  end

#  def self.names_with_action
#    {
#      Click: '$click',
#      View: '$view',
#      Submit: '$submit',
#      Change: '$change'
#    }
#  end

#  def as_bigquery_json
#    as_json(only: [:id, :visit_id, :user_id, :name])
#      .merge(
#        properties: "#{properties}",
#        time: time.strftime('%Y-%m-%d %H:%M:%S')
#      )
#      .reject { |k, v| v.nil? }
#  end
end
