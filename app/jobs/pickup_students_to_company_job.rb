class PickupStudentsToCompanyJob < ActiveJob::Base
  queue_as :default

  def perform(*args)

    companies = Company.where(status: Company::S_ACTIVE)

    companies.each do |company|
      students = Student.where(status: Student::S_ACTIVATED).order(created_at: :desc).limit(5)
      CompanyMailer.pickup_students(students, company).deliver_now
    end

  end

end