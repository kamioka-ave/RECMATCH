class StudentAbility < ApplicationRecord

  belongs_to :student

  validates :ability_1, presence: true, :numericality => { :less_than_or_equal_to => 5 }
  validates :ability_2, presence: true, :numericality => { :less_than_or_equal_to => 5 }
  validates :ability_3, presence: true, :numericality => { :less_than_or_equal_to => 5 }
  validates :ability_4, presence: true, :numericality => { :less_than_or_equal_to => 5 }
  validates :ability_5, presence: true, :numericality => { :less_than_or_equal_to => 5 }
  validates :ability_6, presence: true, :numericality => { :less_than_or_equal_to => 5 }
end
