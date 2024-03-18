module Authorizable
  extend ActiveSupport::Concern

  AS_NONE = 0
  AS_SUBMITTED = 1
  AS_REJECTED = 2
  AS_APPROVED = 3

  included do
    class << self
      def names_with_status
        {
          '未提出' => AS_NONE,
          '承認待ち' => AS_SUBMITTED,
          '却下' => AS_REJECTED,
          '承認済み' => AS_APPROVED
        }
      end
    end
  end
end
