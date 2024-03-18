class QuestionDraftQuestion < ApplicationRecord
  belongs_to :question_draft
  belongs_to :question
end
