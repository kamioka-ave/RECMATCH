class Quit < ApplicationRecord
  has_many :quit_quit_reasons
  has_many :quit_reasons, through: :quit_quit_reasons
  validates :quit_reasons, presence: true
  validates :note, presence: true, if: :reasons_have_others?

  def reasons_have_others?
    quit_reasons.each do |r|
      if r.id == 4 || r.id == 9
        return true
      end
    end

    false
  end

  def quit!(user)
    name = user.last_name
    email = user.email
    transaction do
      self.user_id = user.id
      save!
      user = User.find(user_id)
      user.destroy!
    end

    UserMailer.leaved(name, email).deliver_now
  end
end
