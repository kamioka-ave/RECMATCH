FactoryBot.define do
  factory :ahoy_message, class: Ahoy::Message do
    association :user
    mailer 'My String'
    subject 'My String'
    content 'My String'
    sent_at '2018-11-02 20:07:21'
  end
end
