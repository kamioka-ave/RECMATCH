module ProjectsHelper
  def project_remain_time(finish_at, disp_finished = true)
    r = finish_at.to_i - Time.now.to_i
    if r > 86400      # 60*60*24
      (r / 86400).to_s + '日'
    elsif r > 3600    # 60*60
      (r / 3600).to_s + '時間'
    elsif r > 0
      (r / 60).to_s + '分'
    else
      disp_finished ? '終了' : '0日'
    end
  end

  def project_wait_remain_time(succeeded_at, finish_at)
    limit = succeeded_at + 1.day < finish_at ? succeeded_at + 1.day : finish_at

    r = limit.to_i - Time.now.to_i
    if r > 86400      # 60*60*24
      (r / 86400).to_s + '日'
    elsif r > 3600    # 60*60
      (r / 3600).to_s + '時間'
    elsif r > 0
      (r / 60).to_s + '分'
    else
      '0分'
    end
  end

  def project_deliv_term(project)
    start_on = project.deliv_start_changed_on.present? ? project.deliv_start_changed_on : project.deliv_start_on
    end_on = project.deliv_end_changed_on.present? ? project.deliv_end_changed_on : project.deliv_end_on
    "#{start_on.to_era('%O%E年%-m月%-d日')}〜#{end_on.to_era('%O%E年%-m月%-d日')}"
  end

  def project_deliv_end(project)
    end_on = project.deliv_end_changed_on.present? ? project.deliv_end_changed_on : project.deliv_end_on
    end_on.to_era('%O%E年%-m月%-d日')
  end

  def display_button(social, title)
    case social
    when "facebook"
      content_tag(:a, content_tag(:i, "", class: "fa fa-facebook") + "Facebookでシェア",
        "data-dismiss": :modal, class: "modal-social__btn modal-social__btn--facebook share",
        href: "http://www.facebook.com/sharer.php?u=#{request.original_url}", title: "Facebook シェア", target: "_blank")
    when "twitter"
      content_tag(:a, content_tag(:i, "", class: "fa fa-twitter") + "Twitterでシェア",
        "data-dismiss": :modal, class: "modal-social__btn modal-social__btn--twitter share",
        href: "https://twitter.com/share?url=#{request.original_url}&amp;text=#{title}&amp;",
        title: "Twitter シェア", target: "_blank")
    else
      content_tag(:a, content_tag(:span, "", style: "background-image: url(#{asset_path('social/line-2.png')})", class: "modal-social__line-icon") + "LINEでシェア", "data-dismiss": :modal, class: "modal-social__btn modal-social__btn--line share",
        href: "https://lineit.line.me/share/ui?url=#{request.original_url}&text=#{title}",
        title: "LINE シェア", target: "_blank")
    end
  end
end
