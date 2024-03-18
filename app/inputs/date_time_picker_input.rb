class DateTimePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: "col-md-#{options[:bs_col] || 6} input-group date form_#{@column.type.to_s}") do
      template.concat @builder.text_field(attribute_name, input_html_options)
      template.concat span_table
    end
  end

  def input_html_options
    super.merge(class: 'form-control', readonly: false)
  end

  def span_table
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat icon_table
    end
  end

  def icon_table
    '<span class="glyphicon glyphicon-calendar"></span>'.html_safe
  end
end
