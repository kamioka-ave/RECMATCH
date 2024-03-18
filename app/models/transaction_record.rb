class TransactionRecord < ApplicationRecord
  TR_ORDER = 0                # 注文
  TR_EXECUTED = 1             # 約定
  TR_PAYMENT = 2              # 顧客（学生）支払い
  TR_CANCEL = 3               # 約定日以降未払いによる案件CXL
  TR_INVESTOR_CANCEL = 4      # 顧客（学生）キャンセル
  TR_WIRE = 5                 # 顧客または学生への送金
  TR_DELIVER = 6              # 取引先払い込み
  TR_COMMISSION_TRANSFER = 7  # 手数料支払い要求
  TR_COMMISSION = 8           # 手数料支払い
  TR_REBATED = 9              # 顧客への送金（発行会社の案件キャンセル時に発生する）
  TR_WIRE_COMMISSION = 10     # 顧客への送金手数料
  TR_OTHERS = 11              # その他振替
  TR_REQUIRE_DD_FEE = 12      # その他入金
  TR_DD_FEE = 13              # 審査料の振込入金
  TR_SYSTEM_FEE = 14          # システム利用料振込入金
  TR_SYSTEM_FEE_TRANSFER = 15 # システム利用料勘定への振替

  belongs_to :user
  belongs_to :student
  belongs_to :company
  belongs_to :project
  belongs_to :product
  belongs_to :order
  validates :user_id, presence: true
end
