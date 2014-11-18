module ApplicationHelper

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def poll_title 
    content_tag(:section, class: 'title') do
      content_tag(:i, '', class: 'fa fa-bar-chart fa-3x') + content_tag(:h1, @poll.name)
    end
  end

  def button_link(text, path, icon, color=nil, **options)
    link_to(path, options.merge(class: "button #{color}")) do
      content_tag(:i, '', class: "fa fa-#{icon}") + text
    end
  end

end
