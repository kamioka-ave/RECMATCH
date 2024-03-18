class AdminMailer < ActionMailer::Base
  default(
    from: Rails.env.production? ? '"RECMATCH管理システム" <noreply@recmatch.co.jp>' : '"RECMATCH管理システム" <noreply-staging@recmatch.co.jp>',
    'Message-ID': "#{SecureRandom.uuid}@recmatch.co.jp"
  )

  def company_registered(company)
    @company = company
    mail(
      to: Admin.with_any_role(:recmatch_sales_department).map(&:email),
      subject: "[#{Settings.application_name}] 新たな企業が登録作業中です"
    )
  end

  def company_submitted(company)
    @company = company
    mail(
      to: Admin.with_any_role(:admin, :admin_without_mail, :recmatch_business_department, :recmatch_sales_department).map(&:email),
      subject: "[#{Settings.application_name}] 企業の登録が行われました"
    )
  end

  def company_draft_submitted(company)
    @company = company
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 企業情報の更新依頼が行われました"
    )
  end

  def student_updated(student)
    @student = student
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 学生申請内容が更新されました"
    )
  end

  def student_change_notified(student)
    @student = student
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 学生から変更届が提出されました"
    )
  end

  def student_confirmed(student)
    @student = student
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 学生から取引停止の解除コードを入力しました"
    )
  end

  def student_interview_updated(student, is_locked)
    @student = student
    @is_locked = is_locked
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 学生適合性確認が更新されました"
    )
  end

  def identification_submitted(identification)
    @name = identification_name(identification)
    @identification = identification
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 本人確認書類が提出されました"
    )
  end

  def identification_updated(identification)
    @name = identification_name(identification)
    @identification = identification
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 本人確認書類が更新されました"
    )
  end

  def pep_need_confirm(student)
    @student = student
    mail(
      to: Admin.with_any_role(:admin).map(&:email),
      subject: "[#{Settings.application_name}] 居住地国・PEPsに関する届出書で確認が必要な項目があります"
    )
  end

  def student_submitted(student)
    @student = student
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] サービス利用者の登録申請が行われました"
    )
  end

  def student_transfered(order)
    @order = order
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 学生から振込が行われました"
    )
  end

  def incompatible_transfer(transfer)
    @transfer = transfer
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 不整合の入金がありました"
    )
  end

  def company_proposed(proposal)
    @proposal = proposal
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department, :recmatch_sales_department).map(&:email),
      subject: "[#{Settings.application_name}] 資金調達の申込みが行われました"
    )
  end

  def funding_submitted(company)
    @company = company
    mail(
      to: Admin.with_any_role(:admin, :admin_without_mail, :recmatch_business_department, :recmatch_sales_department).map(&:email),
      subject: "[#{Settings.application_name}] 資金調達の申込みが行われました"
    )
  end

  def company_ir_published(ir)
    @ir = ir
    mail(
      to: Admin.with_any_role(:admin, :admin_without_mail, :recmatch_business_department, :recmatch_sales_department, :ir_checker, :business_manager, :company_reviewer).map(&:email),
      subject: "[#{Settings.application_name}] IR情報が登録されました"
    )
  end

  def company_ir_not_published(company)
    @company = company
    mail(
      to: Admin.with_any_role(:admin_without_mail, :business_manager, :company_reviewer).map(&:email),
      subject: "[#{Settings.application_name}] IR情報が発信されていません"
    )
  end

  def company_other_document_submitted(document)
    @document = document
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department, :recmatch_sales_department).map(&:email),
      subject: "[#{Settings.application_name}] 資料が登録されました"
    )
  end

  def company_preview_document_submitted(document)
    @document = document
    mail(
      to: Admin.with_any_role(:admin, :recmatch_sales_department).map(&:email),
      subject: "[#{Settings.application_name}] #{Company::PreviewDocument.names_with_document_type.key(@document.document_type)}が提出されました"
    )
  end

  def company_review_document_submitted(document)
    @document = document
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department, :recmatch_sales_department).map(&:email),
      subject: "[#{Settings.application_name}] #{Company::ReviewDocument.names_with_document_type.key(@document.document_type)}が提出されました"
    )
  end

  def contact_received(contact)
    @contact = contact

    if contact.file.present?
      attachments[contact.file_identifier] = open(contact.file.url).read
    end

    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      reply_to: contact.email, subject: "[#{Settings.application_name}] お問い合わせがありました"
    )
  end

  def student_receipt_submitted(student)
    @student = student
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 納税書が提出されました"
    )
  end

  def student_ready_to_approve(student)
    @student = student
    mail(
      to: Admin.with_any_role(:admin).map(&:email),
      subject: "[#{Settings.application_name}] 学生を承認してください"
    )
  end

  def students_locked(students, reason)
    @students = students
    @reason = reason
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 学生がロックされました"
    )
  end

  def students_using_same_ip(students)
    @students = students
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 学生が同じIPアドレスを使用しています"
    )
  end

  def commented(project)
    @project = project
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] プロジェクトにコメントがありました"
    )
  end

  def order_record_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 募集明細がダウンロード可能になりました"
    )
  end

  def wait_order_record_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] キャンセル待ち明細がダウンロード可能になりました"
    )
  end

  def student_account_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 顧客勘定元帳がダウンロード可能になりました"
    )
  end

  def student_identification_record_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 本人確認記録簿がダウンロード可能になりました"
    )
  end

  def student_card_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 顧客カードがダウンロード可能になりました"
    )
  end

  def student_ledger_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 顧客台帳がダウンロード可能になりました"
    )
  end

  def transaction_balance_report_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 取引残高報告書がダウンロード可能になりました"
    )
  end

  def order_report_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 取引報告書がダウンロード可能になりました"
    )
  end

  def student_pep_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 居住地国・外国PEPs・FATCA届出書がダウンロード可能になりました"
    )
  end

  def company_account_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 取引先勘定元帳がダウンロード可能になりました"
    )
  end

  def angel_document_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] エンジェル税制書類がダウンロード可能になりました"
    )
  end

  def angel_tax_return_download(download)
    @download = download
    mail(
      to: download.admin.email,
      subject: "[#{Settings.application_name}] 確定申告書類がダウンロード可能になりました"
    )
  end

  def antisocial_student(student)
    @student = student
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 学生が反社会勢力の恐れがあります"
    )
  end

  def antisocial_company(company)
    @company = company
    mail(
      to: Admin.with_any_role(:admin, :recmatch_business_department).map(&:email),
      subject: "[#{Settings.application_name}] 企業が反社会勢力の恐れがあります"
    )
  end

  def remind_change_password(admin)
    mail(
      to: admin.email,
      subject: "[#{Settings.application_name}] 管理画面のパスワード変更をお願いします"
    )
  end

  def student_list_email_delivered(student_list_email)
    @student_list = student_list_email.student_list
    mail(
      to: student_list_email.admin.email,
      subject: "[#{Settings.application_name}] メール配信が完了しました"
    )
  end

  def company_followers_email_delivered(company_followers_email)
    @company = company_followers_email.company
    mail(
      to: company_followers_email.admin.email,
      subject: "[#{Settings.application_name}] メール配信が完了しました"
    )
  end

  def staff_registered(user, company)
    @user = user
    @company = company
    @staff = user.staff
    mail(
      to: user.email,
      subject: "[#{Settings.application_name}] アカウント認証確認"
    )
  end

  def daily_report(report)
    @report = report
    to = Admin.all.map(&:email)

    if Rails.env.production?
      to.push('akiho@tryjin-corp.com')
    end

    mail(
      to: to,
      subject: "[#{Settings.application_name}] デイリーレポート"
    )
  end

  def project_submitted(project_draft)
    @project_draft = project_draft
    mail(
      to: Admin.with_any_role(:admin, :recmatch_sales_manager, :recmatch_business_department).map {|a| a.email },
      subject: "[#{Settings.application_name}] プロジェクトの承認依頼が行われました"
    )
  end

  def project_approved(project_draft, comment)
    @project_draft = project_draft
    @comment = comment
    @receiver = @project_draft.admin.present? ? @project_draft.admin : @project_draft.user
    mail(
      to: @receiver.email,
      subject: "[#{Settings.application_name}] プロジェクトが承認されました"
    )
  end

  def project_rejected(project_draft, comment)
    @project_draft = project_draft
    @comment = comment
    @receiver = @project_draft.admin.present? ? @project_draft.admin : @project_draft.user
    mail(
      to: @receiver.email,
      subject: "[#{Settings.application_name}] プロジェクトが承認されませんでした"
    )
  end

  def project_commented(project)
    @project = project
    mail(
      to: @project.user.email,
      subject: "[#{Settings.application_name}] プロジェクトにコメントがありました"
    )
  end

  private

  def identification_name(identification)
    if identification.user.company.present?
      "#{identification.user. company.name}の#{identification.user.company.president_last_name}"
    elsif identification.user.student.present?
      identification.user.student.name
    else
      identification.user.name
    end
  end

end
