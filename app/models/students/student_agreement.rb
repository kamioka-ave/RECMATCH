class StudentAgreement < ApplicationRecord
  belongs_to :user
  belongs_to :student

  #validate :check_pdf_checked
  validates :agreement, acceptance: { accept: true }

  acts_as_paranoid

  private

  #def check_pdf_checked
  #  errors.add(:pdf1, 'を確認してください') unless pdf1
  #  errors.add(:pdf2, 'を確認してください') unless pdf2
  #end
end
