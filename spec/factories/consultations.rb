FactoryBot.define do
  factory :consultation do
    association :company
    association :supporter
    association :group_chat_category
  end
end
