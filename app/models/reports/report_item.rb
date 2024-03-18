class ReportItem < ApplicationRecord
  belongs_to :report
  belongs_to :order
  belongs_to :student_transaction_record
  validates :report_id, presence: true
end
