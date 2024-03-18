module Sanitizable
  extend ActiveSupport::Concern

  included do
    class << self
      def sanitize_sql_like(str)
        # connection.quote_string(str).gsub(/([%_])/) { "\\" + $1 }
        str.gsub(/([%_])/) { "\\" + $1 }
      end
    end
  end
end