module ApplicationHelper

  def menu_link(controller, title)
    link = ""
    link << "user_" unless controller == "users"
    link << "#{controller.singularize}_path".downcase
    ccs_class = params[:controller] == controller ? "active" : ""
    "<li class='#{ccs_class}'>#{link_to title, send(link, current_user.id) }</li>".html_safe
  end

end
