FactoryBot.define do
  factory :lost_order do
    parent :normal_order
    association :project
    association :product, stocks: 100, price: 20000
  end
end
