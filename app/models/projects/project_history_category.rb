class ProjectHistoryCategory < ApplicationRecord
  belongs_to :project_history
  belongs_to :category
end
