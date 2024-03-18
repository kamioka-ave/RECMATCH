FactoryBot.define do
  factory :staff do
    association :user
    association :company
    first_name "MyString"
    first_name_kana "セイ"
    last_name "MyString"
    last_name_kana "メイ"
  end
end
