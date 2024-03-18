require 'zip'
require 'open-uri'

class StudentMailer < ApplicationMailer

 # def student_approved(student)
 #   @student = student
 #   mail_with_tracking(
 #     user: @student.user,
 #     mail_params: {
 #       to: @student.user.email,
 #       subject: "[#{Settings.application_name}] 学生申請内容が承認されました"
 #     }
 #   )
 # end

  def offer_from_company(student, offers)
    @offers = offers
    @student = student
    mail to: @student.user.email, subject: "【#{Settings.application_name}】 企業からオファーが届いています"
  end

  def applicant_approve_from_company(applicant)
    @applicant = applicant
    @student = @applicant.student
    mail to: @student.user.email, subject: "【#{Settings.application_name}】 オファーが承諾されました"
  end

  def event_approve_from_company(applicant)
    @applicant = applicant
    @student = @applicant.student
    mail to: @student.user.email, subject: "【#{Settings.application_name}】 イベントへの参加が承諾されました"
  end

  def set_meeting_from_company(meet)
    @meet = meet
    @student = @meet.student
    mail to: @student.user.email, subject: "【#{Settings.application_name}】 面談日が設定されました"
  end

  def meeting_will_do(meet)
    @meet = meet
    @student = @meet.student
    mail to: @student.user.email, subject: "【#{Settings.application_name}】 面談前日のご連絡"
  end

  def event_will_do(event_applicant)
    @event_applicant = event_applicant
    @student = @event_applicant.student
    mail to: @student.user.email, subject: "【#{Settings.application_name}】 イベント前日のご連絡"
  end

end
