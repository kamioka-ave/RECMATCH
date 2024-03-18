FactoryBot.define do
  factory :staff_group_chat_category do
    association :staff
    association :group_chat_category
  end
end
