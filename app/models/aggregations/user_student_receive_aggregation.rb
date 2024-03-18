class UserStudentReceiveAggregation < Aggregation
  def self.aggregate(date)
    aggregation = UserStudentReceiveAggregation.find_by(date: date)

    if aggregation.nil?
      r = User.includes(:roles, :student, :profile)
                      .where('users.created_at < ?', date)
                      .where(roles: { id: 2 }, students: { user_id: nil }, profiles: { receive_notification: true })
                      .count
      UserStudentReceiveAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end