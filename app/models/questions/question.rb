class Question < ApplicationRecord
  belongs_to :question_category
  belongs_to :question_draft
  has_many :question_questions, foreign_key: :parent_id, dependent: :destroy
  has_many :questions, through: :question_questions
  is_impressionable counter_cache: true
  acts_as_votable

  default_scope -> { order(:rank) }
end
