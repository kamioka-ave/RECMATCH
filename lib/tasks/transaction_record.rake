namespace :transaction_record do
  task :migrate => :environment do
    StudentTransactionRecord.record_timestamps = false
    StudentTransactionRecord.where(transaction_type: StudentTransactionRecord::TR_EXECUTED).each do |t|
      t.update(transaction_at: t.order.project.execution_at)
    end
    StudentTransactionRecord.record_timestamps = false

    CompanyTransactionRecord.record_timestamps = false
    CompanyTransactionRecord.where(transaction_type: CompanyTransactionRecord::TR_EXECUTED).each do |t|
      t.update(transaction_at: t.project.execution_at)
    end
    CompanyTransactionRecord.record_timestamps = false
  end

  task record: :environment do
    record = StudentTransactionRecord.new(
      user_id: 1079,
      student_id: 595,
      transaction_type: StudentTransactionRecord::TR_PAYMENT,
      transaction_at: Time.zone.parse('2017-08-08 15:00:00'),
      credit: 124_000
    )
    record.save!(validation: false)

    record = StudentTransactionRecord.new(
      user_id: 1079,
      student_id: 595,
      transaction_type: StudentTransactionRecord::TR_WIRE,
      transaction_at: Time.zone.parse('2017-08-09 15:00:00'),
      depository: 124_000
    )
    record.save!(validation: false)
  end
end