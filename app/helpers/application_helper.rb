module ApplicationHelper
  def display_notice_and_alert
    msg = ''
    msg << (content_tag :h3, notice, class: "notice") if notice
    msg << (content_tag :h3, alert, class: "alert") if alert
    sanitize msg
  end
end
