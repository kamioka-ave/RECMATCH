class QuestionDraft < ApplicationRecord
  S_DRAFT = 0
  S_PUBLISHED = 1

  belongs_to :question_category
  has_one :question, dependent: :destroy
  has_many :question_draft_questions, dependent: :destroy
  accepts_nested_attributes_for :question_draft_questions, allow_destroy: true
  has_many :questions, through: :question_draft_questions

  validates :question_category, presence: true
  validates :name, presence: true
  validates :asking, presence: true
  validates :answer, presence: true
  validates :rank, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_save do
    if status == S_PUBLISHED
      question = self.question.present? ? self.question : Question.new
      question.question_draft_id = id
      question.question_category_id = question_category_id
      question.name = name
      question.asking = asking
      question.answer = answer
      question.rank = rank
      question.save

      question.question_questions.destroy_all
      question_draft_questions.each do |qq|
        QuestionQuestion.create(parent_id: question.id, question_id: qq.question_id)
      end
    end
  end

  def self.names_with_status
    {
      下書き: S_DRAFT,
      公開中: S_PUBLISHED
    }
  end
end
