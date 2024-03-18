class CompanyAggregation < Aggregation
  def self.aggregate(date)
    aggregation = CompanyAggregation.find_by(date: date)

    if aggregation.nil?
      r = Company.where('created_at < ?', date).count
      CompanyAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end