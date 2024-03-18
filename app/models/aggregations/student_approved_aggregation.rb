class StudentApprovedAggregation < Aggregation
  def self.aggregate(date)
    aggregation = StudentApprovedAggregation.find_by(date: date)

    if aggregation.nil?
      r = Student.where('approved_at < ?', date)
            .where('rejected_at is NULL or rejected_at >= ?', date)
            .where('waiting_activation_at is NULL or waiting_activation_at >= ?', date)
            .where('activated_at is NULL or activated_at >= ?', date)
            .count
      StudentApprovedAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end