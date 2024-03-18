class CompanyTransactionRecord < TransactionRecord
  validates :transaction_type, presence: true
  validates :transaction_at, presence: true
  validates :depository, presence: true, numericality: { only_integer: true }
  validates :credit, presence: true, numericality: { only_integer: true }

  before_save do
    if transaction_type == TR_WIRE
      project.deliv_at = transaction_at
      project.deliv_price = depository
      project.save!(validate: false)

      NormalOrder.where(project_id: project_id, status: NormalOrder::S_COMPLETE).each do |o|
        o.update!(deliv_at: transaction_at)
        StudentMailer.delivered_to_company(o).deliver_later
      end
    end

    account = Account.find_by!(user_id: user_id)
    account.balance += credit
    account.balance -= depository
    account.save!
    self.balance = account.balance
  end

  def self.names_with_transaction_type
    {
      '募集の扱い' => TR_EXECUTED,
      '申込撤回、契約解除又は失権' => TR_INVESTOR_CANCEL,
      '発行者への送金' => TR_WIRE,
      '手数料勘定への振替' => TR_COMMISSION_TRANSFER,
      '手数料の振込入金' => TR_COMMISSION,
      'その他振替' => TR_OTHERS,
      'その他入金' => TR_REQUIRE_DD_FEE,
      '審査料の振込入金' => TR_DD_FEE,
      'システム利用料振込入金' => TR_SYSTEM_FEE,
      'システム利用料勘定への振替' => TR_SYSTEM_FEE_TRANSFER
    }
  end

  def self.create_executed(project)
    CompanyTransactionRecord.create!(
      user_id: project.company.user_id,
      project_id: project.id,
      company_id: project.company_id,
      transaction_type: TR_EXECUTED,
      transaction_at: project.execution_at,
      amount: project.solicited / project.stock_price,
      credit: project.solicited
    )
  end

  def breakdown
    case transaction_type
    when TR_EXECUTED
      '00'
    when TR_OTHERS
      '02'
    when TR_WIRE
      '03'
    when TR_INVESTOR_CANCEL
      '04'
    when TR_COMMISSION
      '05'
    when TR_COMMISSION_TRANSFER
      '06'
    when TR_REQUIRE_DD_FEE
      '07'
    when TR_DD_FEE
      '08'
    when TR_SYSTEM_FEE
      '09'
    when TR_SYSTEM_FEE_TRANSFER
      '10'
    else
      '99'
    end
  end

  def record_commission!(user_id, company_id, project_id)
    self.user_id = user_id
    self.company_id = company_id
    self.project_id = project_id
    self.transaction_type = CompanyTransactionRecord::TR_COMMISSION

    unless valid?(:commission)
      return false
    end

    transaction do
      save!

      CompanyTransactionRecord.create!(
        user_id: user_id,
        company_id: company_id,
        project_id: project_id,
        transaction_type: CompanyTransactionRecord::TR_COMMISSION_TRANSFER,
        transaction_at: transaction_at,
        depository: credit - 100_000
      )

      # 審査手数料
      CompanyTransactionRecord.create!(
        user_id: user_id,
        company_id: company_id,
        project_id: project_id,
        transaction_type: CompanyTransactionRecord::TR_OTHERS,
        transaction_at: transaction_at,
        depository: 100_000
      )
    end

    true
  end
end
