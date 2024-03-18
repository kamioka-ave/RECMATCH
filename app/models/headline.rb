class Headline < ApplicationRecord
  T_KIGYOU = 0
  T_EVENT = 1
  T_SYSTEM = 2
  T_OTHERS = 3

  S_DRAFT = 0
  S_WAITING = 10
  S_PUBLISHED = 20

  default_scope -> {order(published_at: :desc)}
  scope :active, -> { where(status: S_PUBLISHED).where('published_at < ?', Time.zone.now) }

  validates :title, presence: true, length: { maximum: 0xff }
  validates :headline_type, presence: true
  validates :published_at, presence: true
  validates :body, presence: true, length: { maximum: 0xffff }
  validates :status, presence: true

  def self.names_with_headline_type
    {
      企業情報: T_KIGYOU,
      イベント情報: T_EVENT,
      システム情報: T_SYSTEM,
      その他: T_OTHERS
    }
  end

  def self.names_with_status
    {
      下書き: S_DRAFT,
      配信待ち: S_WAITING,
      配信済: S_PUBLISHED
    }
  end
end
