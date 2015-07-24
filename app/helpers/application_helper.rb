module ApplicationHelper
  def bootstrap_alert
    result = ""
    bootstrap_alert_type = {notice: :success, alert: :danger}

    flash.each do |msg_type, msg|
      alert_type = bootstrap_alert_type[msg_type.to_sym] || :success
      result << content_tag(:div, class: "container alert alert-#{alert_type}") do
        msg.html_safe <<
        content_tag(:button, "x", class: "close", "data-dismiss" => "alert")
      end
    end

    result.html_safe
  end
end
