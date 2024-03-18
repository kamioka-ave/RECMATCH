class Student::ChangeNotification < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  S_NEW = 0
  S_NOTIFIED = 10
  S_WAITING_CONFIRMATION = 11
  S_LOCKED = 12
  S_SENT_DM = 13
  S_CONFIRMED = 20

  attr_accessor :confirmation_code_input

  belongs_to :student, foreign_key: :student_id
  belongs_to :prefecture
  belongs_to :prefecture_prev, class_name: 'Prefecture', foreign_key: :prefecture_id_prev
  belongs_to :bank
  belongs_to :bank_prev, class_name: 'Bank', foreign_key: :bank_id_prev
  belongs_to :bank_branch
  belongs_to :bank_branch_prev, class_name: 'BankBranch', foreign_key: :bank_branch_id_prev

  mount_uploader :file, PrivateFileUploader

  with_options on: :upload do |u|
    u.validates :file, presence: true
  end

  before_create do
    self.confirmation_code = [*2..9, *'a'..'k', *'m'..'n', *'p'..'z', *'A'..'N', *'P'..'Z'].sample(6).join # except 0,1,l,o,O
  end

  def need_identification?
    name_modified || address_modified
  end

  def full_name
    "#{last_name}#{first_name}"
  end

  def full_name_prev
    "#{last_name_prev}#{first_name_prev}"
  end

  def full_name_kana
    "#{last_name_kana}#{first_name_kana}"
  end

  def full_name_kana_prev
    "#{last_name_kana_prev}#{first_name_kana_prev}"
  end

  def full_address
    "#{prefecture.name}#{city}#{address1} #{address2}"
  end

  def full_address_prev
    "#{prefecture_prev.name}#{city_prev}#{address1_prev} #{address2_prev}"
  end

  def notify!
    student_history = StudentHistory.new_with_student(student)

    transaction do
      student.merge_change_notification
      update!(
        status: S_NOTIFIED,
        notified_at: Time.zone.now
      )
      student_history.save!
      student.revision += 1
      student.save!
    end

    StudentMailer.change_notified(student).deliver_later
    #AdminMailer.student_change_notified(student).deliver_later
  end
end
