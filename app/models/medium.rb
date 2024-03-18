class Medium < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
  validates :date, presence: true
end
