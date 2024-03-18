class PhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /^0[0-9]{1,4}-[0-9]{1,4}-[0-9]{4}$/
      object.errors[attribute] << (options[:message] || "電話番号の形式で入力してください（半角数字と-のみ使用できます）")
    end
  end
end