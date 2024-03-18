class UserMailer < ApplicationMailer
  def remind_apply(user)
    @user = user
    track(user: @user)
    mail to: @user.email, subject: "【#{Settings.application_name}】 学生登録に関してのご連絡です"
  end

  def leaving_submitted(profile)
    @profile = profile
    mail to: Admin.with_any_role(:admin, :recmatch_business_department).map {|a| a.email }, subject: "【#{Settings.application_name}】 退会申請が行われました"
  end

  def leaved(name, email)
    @name = name
    mail to: email, subject: "【#{Settings.application_name}】 退会手続き完了のお知らせ"
  end

  def students_using_same_ip(student)
    @student = student
    mail(
      to: student.user.email,
      subject: "【#{Settings.application_name}】 同一IPアドレス検知に関してのご連絡です"
    )
  end

end
