module HeadlinesHelper
  def button_by_headline_type(type)
    case type
    when 0
      'btn-info'
    when 1
      'btn-deeporange'
    when 2
      'btn-success'
    when 3
      'btn-gray'
    end
  end

  def label_by_headline_type(type)
    case type
    when 0
      'label-info'
    when 1
      'label-deeporange'
    when 2
      'label-success'
    when 3
      'label-default'
    end
  end
end