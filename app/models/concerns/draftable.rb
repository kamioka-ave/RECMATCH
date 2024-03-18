module Draftable
  extend ActiveSupport::Concern

  DS_DRAFT = 0
  DS_SUBMITTED = 1
  DS_REJECTED = 2
  DS_APPROVED = 3

  included do
    class << self
      def names_with_status
        {
          '下書き' => DS_DRAFT,
          '承認待ち' => DS_SUBMITTED,
          '却下' => DS_REJECTED,
          '承認済み' => DS_APPROVED
        }
      end
    end
  end
end
