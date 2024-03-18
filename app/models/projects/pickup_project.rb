class PickupProject < ApplicationRecord
  belongs_to :project
  validates :project_id, presence: true
  validates :rank, presence: true, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 0x7fffffff
  }
end
