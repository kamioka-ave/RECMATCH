class StudentStatusHistory < ApplicationRecord
  belongs_to :student
  default_scope -> { order(created_at: :desc) }
end
