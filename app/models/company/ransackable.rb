module Company::Ransackable
  extend ActiveSupport::Concern

  included do
    ransacker :id_string do
      Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
    end

    ransacker :president_name do |parent|
      Arel::Nodes::NamedFunction.new('CONCAT_WS', [
        Arel::Nodes.build_quoted(''), parent.table[:president_last_name], parent.table[:president_first_name]
      ])
    end

    ransacker :president_name_kana do |parent|
      Arel::Nodes::NamedFunction.new('CONCAT_WS', [
        Arel::Nodes.build_quoted(''), parent.table[:president_last_name_kana], parent.table[:president_first_name_kana]
      ])
    end

    def self.ransackable_attributes(auth_object = nil)
      column_names + _ransackers.keys + %w(id_string)
    end
  end
end
