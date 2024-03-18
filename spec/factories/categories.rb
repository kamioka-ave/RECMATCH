FactoryBot.define do
  factory :category do
    projects { [association(:project)] }
    name 'category name'
  end
end
