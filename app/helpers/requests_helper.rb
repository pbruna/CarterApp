module RequestsHelper

  def request_search_field(label, placeholder = '', css_class = '', param = '', autofocus = false)
    default_value = params[:search].nil? ? nil : params[:search][param.to_sym]
    "<span class='add-on'>#{label}</span>#{text_field_tag "search[#{param}]", default_value, :class => css_class, :placeholder => placeholder, :autofocus => autofocus}".html_safe
  end

  def request_label(request)
    css_class = "label label-#{request_css_class(request)}"
  end

  def request_css_class(request)
    request.status_css
  end

  def request_human_size(request)
    # number, unit = number_to_human_size(request.size).split(/\s+/)
    # "#{number}<h3>#{unit}</h3>".html_safe
    number_to_human_size(request.size)
  end
  
  def seconds_to_human_time(seconds)
    return "0<small> s</small>".html_safe if seconds.nil?
    return "#{number_with_precision(seconds, :precision => 1)}<small> s</small>".html_safe if seconds < 91
    (Time.at(seconds).gmtime.strftime('%R:%S') + "<h3> </h3>").html_safe
  end
  
  def display_dst_emails(emails, limit = 10)
    return emails.join(", ") if emails.size < limit
    render :partial => "dst_emails", :locals => {:emails => emails, :limit => limit}
  end
  
  def display_response_text(response_text)
    return response_text unless response_text.match(/^host.*said:/)
    response_text.split(/said:/)[1] + ")"
  end

end
