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

  def button_link(opts={})
    o = {:text => "", :icon => "", :class => "btn", :path => ""}.merge(opts)
    button = "<i class='#{o[:icon]}'></i>"
    link_to "#{button} #{o[:text]}".html_safe, o[:path], :class => o[:class]
  end

end
