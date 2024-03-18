FactoryBot.define do
  factory :admin do
    email 'admin@example.com'
    name 'MyString'
    password 'MyString'
    password_confirmation 'MyString'
    confirmed_at '2010-11-1'

    before(:create) do |a|
      a.add_role(:admin)
    end
  end

  factory :admin_recmatch_sales_department, class: Admin do
    email 'admin@example.com'
    name 'MyString'
    password 'MyString'
    password_confirmation 'MyString'
    confirmed_at '2010-11-1'

    before(:create) do |a|
      a.add_role(:recmatch_sales_department)
    end
  end
end
