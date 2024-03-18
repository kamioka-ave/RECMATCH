class PublicMessage < ApplicationRecord

  validate :message_val

  def message_val
    if name.empty?
      errors[:base] << "名前を入力してください"
    end
    if email.empty?
      errors[:base] << "メールを入力してください"
    end
    if phone.empty?
      errors[:base] << "電話番号を入力してください"
    end
    if description.empty?
      errors[:base] << "メッセージを入力してください"
    end
  end

end
