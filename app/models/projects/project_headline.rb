class ProjectHeadline < ApplicationRecord
  belongs_to :project
  validates :name, presence: true, length: { maximum: 0xff }
  validates :body, presence: true, length: { maximum: 0xffff }
  default_scope -> { order(updated_at: :desc) }
end
