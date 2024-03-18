FactoryBot.define do
  factory :account do
    association :user
    balance 0
  end
end
