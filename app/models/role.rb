class Role < ApplicationRecord
  R_COMPANY = 1
  R_INVESTOR = 2
  R_SUPPORTER = 3
  R_STAFF = 4

  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, polymorphic: true

  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true

  scopify

  before_destroy :cancel

  class << self
    def names
      {
        企業: R_COMPANY,
        学生: R_INVESTOR,
        サポーター: R_SUPPORTER,
        相談用のアカウント: R_STAFF
      }
    end
  end

  private

  def cancel
    false
  end
end
