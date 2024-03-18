FactoryBot.define do
  factory :user_token do
    association :user
    device_token {SecureRandom.base64(10)}
  end
end
