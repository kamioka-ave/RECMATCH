class QuestionQuestion < ApplicationRecord
  belongs_to :parent, foreign_key: :parent_id
  belongs_to :question
end
