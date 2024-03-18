FactoryBot.define do
  factory :cancel_order do
    status 0
    contract_confirmed true
    association :project
    association :product
  end
end
