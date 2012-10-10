module ApplicationHelper

  def current_account
    current_user.account
  end

  def menu_link(controller, title, param = nil)
    link = ""
    link << "#{controller}_path".downcase
    css_class = params[:controller] == controller.pluralize ? "active" : ""
    css_class = "" if params[:controller] == "accounts" && params[:action].in?(%w[index new edit])
    "<li class='#{css_class}'>#{link_to title, send(link, param)}</li>".html_safe
  end
  
  def manage_accounts_link
    css_class = params[:controller] == "accounts" && params[:action].in?(%w[index new edit]) ? "active" : ""
    "<li class='#{css_class}'>#{link_to 'Administrar Cuentas', accounts_path()}</li>".html_safe
  end

  def button_link(opts={})
    o = {:text => "", :icon => "", :class => "btn", :path => ""}.merge(opts)
    button = "<i class='#{o[:icon]}'></i>"
    link_to "#{button} #{o[:text]}".html_safe, o[:path], :class => o[:class]
  end

end
