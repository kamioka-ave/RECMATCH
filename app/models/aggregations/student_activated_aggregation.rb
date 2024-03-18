class StudentActivatedAggregation < Aggregation
  def self.aggregate(date)
    aggregation = StudentActivatedAggregation.find_by(date: date)

    if aggregation.nil?
      r = Student.where('activated_at < ?', date)
            .where('rejected_at is NULL or rejected_at >= ?', date)
            .count
      StudentActivatedAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end