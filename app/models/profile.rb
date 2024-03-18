class Profile < ApplicationRecord
  MAX_IDENTIFICATIONS = 3

  attribute :name, :string, default: '名無し'

  belongs_to :user
  has_many :projects, through: :user
  validates :name, presence: true
  mount_uploader :image, ProfileUploader
  acts_as_paranoid

  def self.names_with_gender
    {
      '男性' => 0,
      '女性' => 1
    }
  end

  def self.names_with_receive_notification
    {
      'メール配信有り' => true,
      'メール配信無し' => false
    }
  end
end
