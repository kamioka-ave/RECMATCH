class AdminRole < ApplicationRecord
  has_and_belongs_to_many :admins, join_table: :admins_admin_roles
  belongs_to :resource, polymorphic: true
  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true

  scopify

  def self.names
    {
      '管理者'.to_sym => 1,
      'RECMATCH管理部'.to_sym => 2,
      'RECMATCH営業'.to_sym => 3,
      'RECMATCH事業部'.to_sym => 4,
      'その他社員'.to_sym => 5
    }
  end

  private

  def cancel
    false
  end
end
