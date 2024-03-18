class OfferToStudentJob < ActiveJob::Base
  queue_as :default

  def perform(*args)

    students = Student.where(status: Student::S_ACTIVATED)

    students.each do |student|
      offers = Offer.where('student_id = ? AND closing_date > ? AND status = ? ', student.id, Time.zone.now, Offer::S_NEW)
      if offers.present?
        StudentMailer.offer_from_company(student, offers).deliver_now
      end
    end

  end

end