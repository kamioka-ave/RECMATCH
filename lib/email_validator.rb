class EmailValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      object.errors[attribute] << (options[:message] || 'Eメールの形式で入力してください')
    end
  end
end
