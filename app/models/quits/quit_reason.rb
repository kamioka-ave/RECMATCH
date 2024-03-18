class QuitReason < ApplicationRecord
  has_many :quit_quit_reasons
  has_many :quits, through: :quit_quit_reasons
  default_scope -> { order(:rank) }
  scope :student_reasons, -> { where(type: 'QuitReasonStudent') }
  scope :company_reasons, -> { where(type: 'QuitReasonCompany') }
end
