class StudentWaitingActivationAggregation < Aggregation
  def self.aggregate(date)
    aggregation = StudentWaitingActivationAggregation.find_by(date: date)

    if aggregation.nil?
      r = Student.where('waiting_activation_at < ?', date)
            .where('rejected_at is NULL or rejected_at >= ?', date)
            .where('activated_at is NULL or activated_at >= ?', date)
            .count
      StudentWaitingActivationAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end