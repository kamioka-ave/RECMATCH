FactoryBot.define do
  factory :product do
    association :project
    stocks 1
    price 10_000
    title 'MyString'
    description 'MyString'
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '1.jpg'), 'image/jpg') }
  end
end
