class StudentAggregation < Aggregation
  def self.aggregate(date)
    aggregation = StudentAggregation.find_by(date: date)

    if aggregation.nil?
      r = Student.where('created_at < ?', date).count
      StudentAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end