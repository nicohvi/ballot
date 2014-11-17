module ApplicationHelper

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def poll_title 
    content_tag(:section, class: 'title') do
      content_tag(:i, '', class: 'fa fa-bar-chart fa-3x') + content_tag(:h1, @poll.name)
    end
  end

end
