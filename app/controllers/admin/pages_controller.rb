class Admin::PagesController < Admin::AdminController
  def index
    @students = Student.all
    #@student_interviews = StudentInterview.where.not(student_id: nil)
    @prefectures_students = Prefecture.all.map do |p|
      {
        name: p.name,
        value: @students.select { |i| i.prefecture_id == p.id }.count
      }
    end
    @interests_students = CompanyBusinessType.all.map do |p|
      {
        name: p.name,
        value: @students.select { |i| i.industry_1 == p.id or i.industry_2 == p.id or i.industry_3 == p.id}.count
      }
    end
    #@interests_students = StudentInterest.all.map do |i|
    #  {
    #    name: i.name,
    #    value: i.student_interview_student_interests.count
    #  }
    #end
    #@how_to_knows_students = StudentInterview.names_with_how_to_know_abbr.map do |k, v|
    #  {
    #    name: k,
    #    value: @student_interviews.select { |i| i.how_to_know == v }.count
    #  }
    #end
  end

  def user_aggregates
    term = params[:term].to_i
    results = []
    date = Date.today

    14.times do
      results.push(
        date: date.yesterday.strftime('%m/%d'),
        all_user_counts: UserAggregation.aggregate(date),
        #all_counts: UserStudentAggregation.aggregate(date),
        all_counts: StudentAggregation.aggregate(date),
        all_company_counts: CompanyAggregation.aggregate(date),
        receive_counts: UserStudentReceiveAggregation.aggregate(date),
        not_receive_counts: UserStudentNotReceiveAggregation.aggregate(date)
      )

      date -= term
    end

    render json: results.reverse
  end

  def student_aggregates
    term = params[:term].to_i
    results = []
    date = Date.today

    14.times do
      results.push(
        date: date.yesterday.strftime('%m/%d'),
        all_counts: StudentAggregation.aggregate(date),
        new_counts: StudentNewAggregation.aggregate(date),
        rejected_counts: StudentRejectedAggregation.aggregate(date),
        in_review_counts: StudentInReviewAggregation.aggregate(date),
        approved_counts: StudentApprovedAggregation.aggregate(date),
        waiting_activation_counts: StudentWaitingActivationAggregation.aggregate(date),
        activated_counts: StudentActivatedAggregation.aggregate(date)
      )

      date -= term
    end

    render json: results.reverse
  end

  def company_aggregates
    term = params[:term].to_i
    results = []
    date = Date.today

    14.times do
      results.push(
        date: date.yesterday.strftime('%m/%d'),
        all_counts: CompanyAggregation.aggregate(date)
      )

      date -= term
    end

    render json: results.reverse
  end

  def access_denied; end
end