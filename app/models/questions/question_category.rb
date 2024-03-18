class QuestionCategory < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :question_drafts, dependent: :destroy

  validates :type, presence: true
  validates :name, presence: true

  def self.names_with_type
    {
      一般的な質問: 'CommonQuestionCategory',
      学生様: 'StudentQuestionCategory',
      企業様: 'CompanyQuestionCategory'
    }
  end
end
