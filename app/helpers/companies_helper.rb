module CompaniesHelper
  def active?(params, key, value)
    if params.has_key?(key)
      if params[key].kind_of?(Array)
        params[key].include?(value)
      else
        params[key] == value
      end
    else
      false
    end
  end

  def build_filter_params(params, key, value)
    r = {}
    params.each do |k, v|
      if v.kind_of?(Array)
        r[k] = []
        v.each {|t| r[k] << t }
      else
        r[k] = v
      end
    end

    if r.has_key?(key)
      if r[key].kind_of?(Array)
        if r[key].include?(value)
          if r[key].size > 0
            r[key].delete(value)
            if r[key].size == 1
              tmp = r[key][0]
              r[key] = tmp
            end
          else
            r.delete(key)
          end
        else
          r[key].push(value)
        end
      else
        if r[key] == value
          r.delete(key)
        else
          tmp = r[key]
          r[key] = [tmp, value]
        end
      end
    else
      r[key] = value
    end

    r
  end

  def company_follower_type(follower)
    if follower.student.present?
      '学生'
    elsif follower.user.present?
      'ユーザー'
    else
      'フォロワー'
    end
  end

  def company_follower_status(follower)
    if follower.student.present?
      Student.names_with_status.key(follower.student.status)
    elsif follower.user.present?
      'ユーザー'
    else
      'フォロワー'
    end
  end
end
