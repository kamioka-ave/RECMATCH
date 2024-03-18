class QuitQuitReason < ApplicationRecord
  belongs_to :quit
  belongs_to :quit_reason
end
