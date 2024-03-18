module ApplicationHelper
  def show_time(time)
    time.strftime('%H:%M')
  end

  def show_date(date)
    l(date, format: :long)
  end

  def show_datetime(time, smart = true)
    if smart
      t = Time.now.to_i - time.to_i
      if t > 86400    # 60*60*24
        time.strftime("%Y年%-m月%-d日")
      elsif t > 3600  # 60*60
        (t / (3600)).to_s + "時間前"
      else
        (t / 60).to_s + "分前"
      end
    else
      time.strftime("%Y年%-m月%-d日 %H:%M")
    end
  end

  def show_age(date)
    age = Date.today - date
    (age.to_i / 365).to_s + "歳"
  end

  def container_less?(controller, controller_path)
    if controller_path == 'pages' && controller.action_name == 'index'
      true
    elsif controller_path == 'projects' && controller.action_name == 'index'
      true
    elsif controller_path == 'projects' && controller.action_name == 'show'
      true
    elsif controller_path == 'profiles' && controller.action_name == 'show'
      true
    elsif controller_path == 'mypage/pages'
      true
    elsif controller_path == 'mypage/proposals' && controller.action_name == 'new'
      true
    else
      false
    end
  end

  def mypage_account_page?
    if controller_path == 'mypage/pages' && controller.action_name == 'account'
      true
    elsif controller_path == 'mypage/profiles'
      true
    elsif (controller_path == 'users/registrations' && controller.action_name == 'edit') || (controller_path == 'users/registrations' && controller.action_name == 'update')
      true
    elsif controller_path == 'mypage/emails'
      true
    elsif controller_path == 'mypage/user_connections'
      true
    else
      false
    end
  end

  def link_to_add_fields(name, f, association, path)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(path + association.to_s.singularize + '_fields', f: builder)
    end
    link_to('#', class: 'add_fields', data: { id: id, fields: fields.gsub('\n', '') }) do
      '<i class="fa fa-plus-circle""></i>'.html_safe + " #{name}"
    end
  end

  def link_to_add_search_fields(f, type)
    new_object = f.object.send("build_#{type}")
    id = new_object.object_id
    name = "#{type}_fields"
    fields = f.send(name, new_object, child_index: id) do |builder|
      render(name, f: builder)
    end

    link_to('#', class: 'add_fields', data: { id: id, fields: fields.gsub('\n', ''), 'field-type' => type }) do
      '<i class="fa fa-plus-circle""></i>'.html_safe + ' 追加'
    end
  end

  def hundred_million(num)
    num / 100000000
  end

  def ten_thousand(num)
    if num >= 100000000
      (num % 100000000) / 10000
    else
      num / 10000
    end
  end

  def ten_million(num)
    if num >= 100000000
      (num % 100000000) / 10000000
    else
      num / 10000000
    end
  end

  def jquery_view(name, turbolinks: false, **args)
    js_args = args.values.map do |value|
      if value.nil?
        'null'
      elsif value.instance_of?(String)
        "'#{value}'"
      elsif value.instance_of?(Array)
        "#{value.to_json}"
      else
        value
      end
    end
    view = "#{name}(#{js_args.join(',')})"
    var = name.gsub(/\./, '_')

    if turbolinks
      # content_tag(:script, "$(document).on('turbolinks:load', function() {console.log('turbolinks:load'); #{view}});".html_safe)
      script = <<-EOS
        var #{var} = null;
        document.addEventListener(
          'turbolinks:load',
          function() {
            if (#{var} == null) {
              // console.log('#{var}', new Date());
              #{var} = new #{view};
            }
          },
          { once: true }
        );
        document.addEventListener(
          'turbolinks:before-cache',
          function() {
            // delete #{var};
            #{var} = null;
          }
        );
      EOS
      content_tag(:script, script.html_safe)
    else
      content_tag(:script, "$(function () {new #{view}});".html_safe)
    end
  end

  def index_with_pagination(collection, current_page_index)
    (collection.current_page - 1) * collection.limit_value + current_page_index + 1
  end
end
