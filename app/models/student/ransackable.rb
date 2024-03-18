module Student::Ransackable
  extend ActiveSupport::Concern

  included do
    ransacker :id_string do
      Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
    end

    ransacker :full_name do |parent|
      Arel::Nodes::NamedFunction.new('CONCAT_WS', [
        Arel::Nodes.build_quoted(''), parent.table[:last_name], parent.table[:first_name]
      ])
    end

    ransacker :full_name_kana do |parent|
      Arel::Nodes::NamedFunction.new('CONCAT_WS', [
        Arel::Nodes.build_quoted(''), parent.table[:last_name_kana], parent.table[:first_name_kana]
      ])
    end

    def self.ransackable_attributes(auth_object = nil)
      column_names + _ransackers.keys + %w(id_string)
    end

    def self.conditionable_attributes
      {
        id: '学生ID',
        id_string: '学生ID（文字列）',
        full_name: '学生の名前',
        full_name_kana: '学生の名前（カナ）',
        status: '学生状況',
        created_at: '学生登録日時',
        rejected_at: '学生却下日時',
        applied_at: '学生申請日時',
        approved_at: '学生承認日時',
        waiting_activation_at: 'アクティベートコード入力待ち開始日時',
        activated_at: 'アクティベート日時',
        locked_at: 'ロックされた日時',
        is_mail_target: 'メール対象フラグ',
        user_id: 'ユーザーID',
        user_id_string: 'ユーザーID（文字列）',
        user_email: 'メールアドレス',
        orders_project_name: 'プロジェクト名',
        orders_status: '申込状態',
        orders_price: '申込金額',
        orders_order_at: '申込日時',
        orders_canceled_at: '申込キャンセル日時',
        enable_reapply: '再申請'
      }
    end

    def self.conditionable_predicates
      {
        eq: Ransack::Translate.predicate('eq'),
        not_eq: Ransack::Translate.predicate('not_eq'),
        gt: Ransack::Translate.predicate('gt'),
        gteq: Ransack::Translate.predicate('gteq'),
        lt: Ransack::Translate.predicate('lt'),
        lteq: Ransack::Translate.predicate('lteq'),
        cont: Ransack::Translate.predicate('cont'),
        not_cont: Ransack::Translate.predicate('not_cont'),
        start: Ransack::Translate.predicate('start'),
        end: Ransack::Translate.predicate('end')
      }
    end
  end
end
