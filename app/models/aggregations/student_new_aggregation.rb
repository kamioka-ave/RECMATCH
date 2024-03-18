class StudentNewAggregation < Aggregation
  def self.aggregate(date)
    aggregation = StudentNewAggregation.find_by(date: date)

    if aggregation.nil?
      r = Student.where('created_at < ?', date)
            .where('rejected_at is NULL or rejected_at >= ?', date)
            .where('applied_at is NULL or applied_at >= ?', date)
            .count
      StudentNewAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end