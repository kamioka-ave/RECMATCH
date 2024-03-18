class UserToken < ApplicationRecord
  belongs_to :user

  validates :device_token, presence: true, uniqueness: {scope: :user_id}

  scope :not_expired, ->{where('expires_at >= ?', Time.zone.now)}

  before_save {self.expires_at = 1.days.from_now}
end
