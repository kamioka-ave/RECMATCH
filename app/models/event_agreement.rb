class EventAgreement < ApplicationRecord
  validates :agree_with_clause, acceptance: true
end
