class UserStudentAggregation < Aggregation
  def self.aggregate(date)
    aggregation = UserStudentAggregation.find_by(date: date)

    if aggregation.nil?
      r = User.includes(:roles, :student)
                      .where('users.created_at < ?', date)
                      .where(roles: { id: 2 }, students: { user_id: nil })
                      .count
      UserStudentAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end