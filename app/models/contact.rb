class Contact < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates_format_of :email, with: /\A([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})\z/i
  validates :message, presence: true, length: { maximum: 0xffff }
  mount_uploader :file, ContactUploader

  after_create_commit do
    #AdminMailer.contact_received(self).deliver_later
  end
end
