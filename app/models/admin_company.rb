class AdminCompany < ApplicationRecord
  belongs_to :admin
  belongs_to :company

  validates :admin_id, presence: true
  validates :company_id, presence: true
end
