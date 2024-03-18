FactoryBot.define do
  factory :student do
    association :user
    first_name 'MyString'
    last_name 'MyString'
    birth_on '1980-06-24'
    status 5

    after(:create) do |i|
      create(:student_pep, student: i)
    end
  end
end
