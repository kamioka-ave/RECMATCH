class Student::Applicant < ApplicationRecord

  S_BOOK = 0
  S_FAILED = 1
  S_PROGRESS = 2
  S_PROMISE = 3
  S_FINISHED = 4

  M_SKYPE = 0
  M_LINE = 1
  M_TELL = 2

  belongs_to :student

  validates :status, presence: true
  validates :book1_at, presence: true
  validates :book2_at, presence: true
  validates :book3_at, presence: true
  validates :meet_type, presence: true
  validate :book_at_validate

  def book_at_validate
    if book1_at < Time.zone.now.since(4.days)
      errors.add(:book1_at, '予約日は5日後以降の日付を設定してください。')
    elsif book2_at < Time.zone.now.since(4.days)
      errors.add(:book2_at, '予約日は5日後以降の日付を設定してください。')
    elsif book3_at < Time.zone.now.since(4.days)
      errors.add(:book3_at, '予約日は5日後以降の日付を設定してください。')
    end
  end

  def self.names_with_status
    {
      予約受付済: S_BOOK,
      キャンセル: S_FAILED,
      日程調整中: S_PROGRESS,
      確約: S_PROMISE,
      終了: S_FINISHED
     }
  end

  def self.names_with_meet_type
    {
      Skype: S_BOOK,
      LINE: S_FAILED,
      電話: S_PROGRESS
    }
  end

end
