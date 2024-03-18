class Ahoy::Message < ActiveRecord::Base
  self.table_name = 'ahoy_messages'
  belongs_to :user, (ActiveRecord::VERSION::MAJOR >= 5 ? { optional: true } : {}).merge(polymorphic: true)
  belongs_to :messageable, polymorphic: true

  def apply_ses_notification!(notification)
    type = notification['notificationType']

    case type
    when 'Bounce'
      bounce = notification['bounce']
      recipients = bounce['bouncedRecipients']
      recipients.each do |r|
        if r['emailAddress'] == user.email
          update_column(:bounced_at, bounce['timestamp'].to_datetime)
        end
      end
    when 'Delivery'
      delivery = notification['delivery']
      recipients = delivery['recipients']
      recipients.each do |r|
        if r == user.email
          update_column(:delivered_at, delivery['timestamp'].to_datetime)
        end
      end
    end
  end
end