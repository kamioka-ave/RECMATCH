FactoryBot.define do
  factory :project do
    proposal_id 1
    name 'テストプロジェクト'
    short_description ''
    description ''
    solicit 10_000
    solicited 0
    solicit_limit 20_000
    interview_movie ''
    status 0
    contract ''
    start_at '2016-06-24 15:15:17'
    finish_at '2030-06-24 15:15:17'
    project_draft_id 1
    is_succeeded_with_limit false
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '1.jpg'), 'image/jpg') }
    association :company
  end
end
