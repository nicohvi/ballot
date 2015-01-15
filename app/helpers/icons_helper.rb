module IconsHelper
  
  def button_link(text, path, icon, **options)
    link_to(path, options.merge(class: "button #{options[:class]}")) do
      content_tag(:i, '', class: "icon-#{icon}") + content_tag(:span, text)
    end
  end

  def icon_button(icon, **options)
    button_tag(type: :button, class: options[:class]) do
      content_tag(:i, '', class: "icon-#{icon}")
    end
  end

  def icon_link(path, icon, **options)
    link_to(path, options) do
      content_tag(:i, '', class: "icon-#{icon}", title: options[:title]) 
    end
  end

  def icon_aside(icon)
    content_tag(:aside) do
      content_tag(:i, '', class: "icon-#{icon}")
    end
  end

end
