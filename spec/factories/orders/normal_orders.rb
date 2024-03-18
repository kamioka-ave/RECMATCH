FactoryBot.define do
  factory :normal_order do
    status 0
    contract_confirmed true
    association :project
    association :product, stocks: 300, price: 60000
  end
end
