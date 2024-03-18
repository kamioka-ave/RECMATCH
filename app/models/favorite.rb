class Favorite < ApplicationRecord

  belongs_to :student, class_name: 'Student', foreign_key: 'student_id'

  validates :company_id, presence: true
  validates :student_id, presence: true
  validates :direction, presence: true
end
