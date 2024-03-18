FactoryBot.define do
  sequence :supporter_email do |n|
    "supporter#{n}@example.com"
  end

  sequence :student_email do |n|
    "student#{n}@example.com"
  end

  sequence :user_email do |n|
    "user#{n}@example.com"
  end

  factory :staff_user, class: User do
    email { generate :user_email }
    password 'test1234'
    password_confirmation 'test1234'
    confirmed_at '2010-11-1'
    before(:create) do |u|
      u.add_role(:staff)
    end

    after(:create) do |u|
      create(:account, user: u)
      create(:profile, user: u)
      create(:staff, user: u)
    end
  end

  factory :student_user, class: User do
    email { generate :student_email }
    password 'password'
    confirmed_at '2016-12-20 20:07:21'

    before(:create) do |u|
      u.add_role(:student)
    end

    after(:create) do |u|
      create(:account, user: u)
      create(:profile, user: u)
      create(:student, user: u)
    end
  end

  factory :company_user, class: User do
    email 'company@example.com'
    password 'password'
    confirmed_at '2016-12-20 20:07:21'

    before(:create) do |u|
      u.add_role(:company)
    end

    after(:create) do |u|
      create(:account, user: u)
      create(:profile, user: u)
      company = create(:company, user: u)
      create(:company_agreement, company: company, user: u)
    end
  end

  factory :supporter_user, class: User do
    email { generate :supporter_email }
    password 'test1234'
    password_confirmation 'test1234'
    confirmed_at '2010-11-1'

    before(:create) do |u|
      u.add_role(:supporter)
    end

    after(:create) do |u|
      create(:account, user: u)
      create(:profile, user: u)
      create(:supporter, user: u)
    end
  end
end
