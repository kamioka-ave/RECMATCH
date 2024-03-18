FactoryBot.define do
  factory :student_pep do
    association :student
    country 0
    peps false
    fatca false
    country_agreement true
    peps_agreement true
    fatca_agreement true
  end
end
