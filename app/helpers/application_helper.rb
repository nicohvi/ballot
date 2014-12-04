module ApplicationHelper

  def poll_title 
    content_tag(:section, class: 'title') do
      content_tag(:i, '', class: 'fa fa-bar-chart fa-3x') + content_tag(:h1, @poll.name)
    end
  end

  def button_link(text, path, icon, color=nil, **options)
    link_to(path, options.merge(class: "button #{color}")) do
      content_tag(:i, '', class: "fa fa-#{icon}") + content_tag(:span, text)
    end
  end

  def icon_link(path, **options)
    link_to(path, options) do
      content_tag(:i, '', class: "fa fa-#{options[:icon]} fa-2x", title: options[:title])
    end
  end

end
