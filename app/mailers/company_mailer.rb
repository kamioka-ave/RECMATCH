class CompanyMailer < ApplicationMailer

  def company_approved(company)
    @company = company
    mail to: @company.user.email, subject: "【#{Settings.application_name}】 登録完了のご連絡"
  end

  def company_rejected(company)
    @company = company
    mail to: @company.user.email, subject: "【#{Settings.application_name}】 企業登録審査結果のご連絡"
  end

  def offer_from_student(applicant)
    @applicant = applicant
    @company = @applicant.project.company
    mail to: @company.user.email, subject: "【#{Settings.application_name}】 学生からオファーが届きました"
  end

  def offer_approve(offer)
    @offer = offer
    @company = @offer.company
    mail to: @company.user.email, subject: "【#{Settings.application_name}】 オファーが承諾されました"
  end

  def event_applicant(applicant)
    @applicant = applicant
    @company = @applicant.event.company
    mail to: @company.user.email, subject: "【#{Settings.application_name}】 学生からイベントに応募がございました"
  end

  def meeting_will_do(meet)
    @meet = meet
    @company = @meet.company
    mail to: @company.user.email, subject: "【#{Settings.application_name}】 面談前日のご連絡"
  end

  def pickup_students(students, company)
    @students = students
    @company = company
    mail to: @company.user.email, subject: "【#{Settings.application_name}】 ピックアップ学生更新のご連絡"
  end

  #def system_fare(fare, company, user)
  #  @fare = fare
  #  @company = company
  #  @user = user
  #  mail(
  #    to: user.email,
  #    subject: "[#{Settings.application_name}] システム利用料通知") do |format|
  #      format.text
  #      format.pdf do
  #        attachments['SystemFare.pdf'] = WickedPdf.new.pdf_from_string(
  #          render_to_string(:pdf => 'SystemFarePDF',:template => 'admin/companies/fares/fare.pdf.erb')
  #        )
  #      end
  #   end
  #end
end
