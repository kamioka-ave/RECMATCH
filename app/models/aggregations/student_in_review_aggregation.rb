class StudentInReviewAggregation < Aggregation
  def self.aggregate(date)
    aggregation = StudentInReviewAggregation.find_by(date: date)

    if aggregation.nil?
      r = Student.where('applied_at < ?', date)
            .where('rejected_at is NULL or rejected_at >= ?', date)
            .where('approved_at is NULL or approved_at >= ?', date)
            .where('waiting_activation_at is NULL or waiting_activation_at >= ?', date)
            .where('activated_at is NULL or activated_at >= ?', date)
            .count
      StudentInReviewAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end