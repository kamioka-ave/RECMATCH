class ChatMessage < ApplicationRecord

  belongs_to :student
  belongs_to :company
end
