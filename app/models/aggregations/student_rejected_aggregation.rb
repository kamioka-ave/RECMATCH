class StudentRejectedAggregation < Aggregation
  def self.aggregate(date)
    aggregation = StudentRejectedAggregation.find_by(date: date)

    if aggregation.nil?
      r = Student.where('rejected_at < ?', date)
            .count
      StudentRejectedAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end