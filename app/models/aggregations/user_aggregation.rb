class UserAggregation < Aggregation
  def self.aggregate(date)
    aggregation = UserAggregation.find_by(date: date)

    if aggregation.nil?
      r = User.includes(:roles)
                     .where('users.created_at < ?', date)
                     .where(roles: { id: 1 })
                     .or(User.includes(:roles).where(roles: { id: 2 })).count
      UserAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end