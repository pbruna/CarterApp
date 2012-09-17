module RequestsHelper
  
  def request_search_field(label, placeholder = '', css_class = '', param = '')
    default_value = params[:search].nil? ? nil : params[:search][param.to_sym]
    "<span class='add-on'>#{label}</span>#{text_field_tag "search[#{param}]", default_value, :class => css_class, :placeholder => placeholder}".html_safe
  end
  
end
