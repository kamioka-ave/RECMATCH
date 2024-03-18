class StudentHistory < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :student
  belongs_to :prefecture
  belongs_to :bank
  belongs_to :bank_branch

  def self.new_with_student(student)
    params = student.attributes.compact
    params.delete('id')
    params.delete('user_id')
    params.delete('tax_payment_receipt')
    params.delete('draft_id')
    params.delete('published_at')
    params.delete('trashed_at')
    params.delete('tax_payment_receipt_status')
    params.delete('status')
    params.delete('activation_code')
    params.delete('activated_at')
    params.delete('applied_at')
    params.delete('approved_at')
    params.delete('rejected_at')
    params.delete('waiting_activation_at')
    params.delete('term_confirmed_at')
    params.delete('card_note')
    params.delete('locked_at')
    params.delete('lock_reason')
    params.delete('is_identification_passed')
    params.delete('identified_at')
    params.delete('identifier_id')
    params.delete('is_antisocial_check_passed')
    params.delete('antisocial_checked_at')
    params.delete('antisocial_checker_id')
    params.delete('approver_id')
    params.delete('reconfirm_applied_at')
    params.delete('reconfirmed_at')
    params.delete('is_ignore_ip_check')
    params.delete('is_ignore_phone_check')
    params.delete('change_history')
    params.delete('is_mail_target')
    params.delete('remind_apply_job_id')
    params.delete('remind_activation_job_id')
    params.delete('total_order_count')
    params.delete('total_order_price')
    params.delete('total_investment_price')
    params.delete('remind_update_sent_at')
    params.delete('enable_reapply')
    params.delete('reapplied')
    params.delete('follows_count')
    history = StudentHistory.new(params)
    history.student_id = student.id
    history
  end

  def full_name
    "#{last_name}#{first_name}"
  end

  def full_name_kana
    "#{last_name_kana}#{first_name_kana}"
  end

  def full_address
    "#{prefecture.name}#{city}#{address1}#{address2}"
  end

  def as_json(options = {})
    super(options).merge(
      full_name: full_name,
      full_name_kana: full_name_kana,
      full_address: full_address,
      gender: Student.names_with_gender.key(gender),
      birth_on: ApplicationController.helpers.l(birth_on),
      prefecture: prefecture.name,
      job: Student.names_with_job.key(job),
      business: Student.names_with_business.key(business),
      bank: bank.present? ? bank.name_with_bank : '',
      bank_branch: bank_branch.present? ? bank_branch.name_with_branch : '',
      bank_account_type: bank_account_type.present? ? Student.names_with_bank_account_type.key(bank_account_type) : '',
      updated_at: ApplicationController.helpers.l(updated_at)
    )
  end

  def changes_with_prev(prev)
    notes = []
    notes << "氏名: #{full_name} -> #{prev.full_name}" if last_name != prev.last_name || first_name != prev.first_name
    notes << "氏名（カナ）: #{full_name_kana} -> #{prev.full_name_kana}" if last_name_kana != prev.last_name_kana || first_name_kana != prev.first_name_kana
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.gender')}: #{Student.names_with_gender.key(gender)} -> #{Student.names_with_gender.key(prev.gender)}" if prev.gender != gender
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.birth_on')}: #{ApplicationController.helpers.l(birth_on)} -> #{ApplicationController.helpers.l(prev.birth_on)}" if prev.birth_on != birth_on
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.zip_code')}: #{zip_code} -> #{prev.zip_code}" if prev.zip_code != zip_code
    notes << "住所: #{full_address} -> #{prev.full_address}" if prefecture_id != prev.prefecture_id || city != prev.city || address1 != prev.address1 || address2 != prev.address2
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.phone')}: #{phone} -> #{prev.phone}" if prev.phone != phone
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.phone_mobile')}: #{phone_mobile} -> #{prev.phone_mobile}" if prev.phone_mobile != phone_mobile
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.job')}: #{Student.names_with_job.key(job)} -> #{Student.names_with_job.key(prev.job)}" if prev.job != job
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.job_details')}: #{job_details} -> #{prev.job_details}" if job_details != nil && prev.job_details != job_details
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.business')}: #{Student.names_with_business.key(business)} -> #{Student.names_with_business.key(prev.business)}" if prev.business != business
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.business_details')}: #{Student.names_with_business_details.key(business_details)} -> #{Student.names_with_business_details.key(prev.business_details)}" if prev.business_details != business_details
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.company')}: #{company} -> #{prev.company}" if prev.company != company
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.phone_company')}: #{phone_company} -> #{prev.phone_company}" if prev.phone_company != phone_company
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.email_company')}: #{email_company} -> #{prev.email_company}" if prev.email_company != email_company
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.bank')}: #{bank.present? ? bank.name : ''} -> #{prev.bank.present? ? prev.bank.name : ''}" if prev.bank_id != bank_id
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.bank_branch')}: #{bank_branch.present? ? bank_branch.name : ''} -> #{prev.bank_branch.present? ? prev.bank_branch.name : ''}" if prev.bank_branch_id != bank_branch_id
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.bank_account_type')}: #{Student.names_with_bank_account_type.key(bank_account_type)} -> #{Student.names_with_bank_account_type.key(prev.bank_account_type)}" if prev.bank_account_type != bank_account_type
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.bank_account_number')}: #{bank_account_number} -> #{prev.bank_account_number}" if prev.bank_account_number != bank_account_number
    notes << "#{ApplicationController.helpers.t('activerecord.attributes.student.bank_account_name')}: #{bank_account_name} -> #{prev.bank_account_name}" if prev.bank_account_name != bank_account_name
    notes
  end
end
