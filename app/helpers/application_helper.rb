module ApplicationHelper

  def current_account
    current_user.account
  end

  def menu_link(controller, title)
    link = ""
    link << "#{controller.singularize}_path".downcase
    ccs_class = params[:controller] == controller ? "active" : ""
    "<li class='#{ccs_class}'>#{link_to title, send(link, current_account.id) }</li>".html_safe
  end

end
