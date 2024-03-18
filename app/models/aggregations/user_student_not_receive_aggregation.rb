class UserStudentNotReceiveAggregation < Aggregation
  def self.aggregate(date)
    aggregation = UserStudentNotReceiveAggregation.find_by(date: date)

    if aggregation.nil?
      r = User.includes(:roles, :student, :profile)
                      .where('users.created_at < ?', date)
                      .where(roles: { id: 2 }, students: { user_id: nil }, profiles: { receive_notification: false })
                      .count
      UserStudentNotReceiveAggregation.create!(
        date: date,
        result: r
      )
    else
      r = aggregation.result
    end

    r
  end
end