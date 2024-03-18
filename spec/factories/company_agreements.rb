FactoryBot.define do
  factory :company_agreement do
    association :user
    association :company
    pdf1 true
    pdf2 true
    pdf3 true
    pdf4 true
    agreement true
    terms10_agreed true
  end
end
