module FlashHelper
  ALERT_TYPES = [:success, :info, :warning, :danger] unless const_defined?(:ALERT_TYPES)

  def bootstrap_flash(options = {})
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
            content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                msg, :class => "alert fade in alert-#{type} #{options[:class]}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def growl_flash(options = {})
    if !flash.empty?
      flash_messages = "<script>";
      flash.each do |type, message|
        next if message.blank?

        type = type.to_sym
        type = :success if type == :notice
        type = :danger  if type == :alert
        type = :danger  if type == :error
        next unless ALERT_TYPES.include?(type)

        Array(message).each do |msg|
          flash_messages += "notify('', '#{msg}', 'top', 'center', '', '#{type}', '', '');"
        end
      end
      flash_messages += "</script>";
      flash_messages.html_safe
    end
  end
end
