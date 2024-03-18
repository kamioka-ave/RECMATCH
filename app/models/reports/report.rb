class Report < ApplicationRecord

  belongs_to :user
  belongs_to :student
  belongs_to :project
  has_many :report_items, dependent: :destroy

  validates :report_type, presence: true
  validate :sheet_length


  def sheet_length
    sheet_for_validation = sheet.gsub(/\r\n/,"a")
    if sheet_for_validation.length > 400
      errors.add(:sheet, "は400文字以内で入力してください。")
    end
  end

  def self.names_with_type
    {
      'コミュニケーション能力' => 0,
      'コミット力(計画性)' => 1,
      'チャレンジ精神力' => 2,
      'リーダーシップ能力' => 3,
      '思考力' => 4,
      'チームワーク能力' => 5,
      'グローバル素養力' => 6,
      'その他' => 10
    }
  end

end
