module ApplicationHelper

  def poll_title(**opts)
    content_tag(:section, class: 'poll-title') do
      content_tag(:i, '', class: 'icon-graph-pie') + content_tag(:h1, @poll.name) +
      if opts[:edit]
        content_tag(:section, class: 'form') do
          form_for(@poll, remote: true) do |f|
              f.text_field :name
          end
        end + content_tag(:i, '', class:'icon-pencil edit-title') 
      end
    end
  end

  def paginate(collection, options={})
    options.merge!({ previous_label: '←', next_label: '→' })
    will_paginate(collection, options)
  end

  def button_link(text, path, icon, color=nil, **options)
    link_to(path, options.merge(class: "button #{color} #{options[:class]}")) do
      content_tag(:i, '', class: "icon-#{icon}") + content_tag(:span, text)
    end
  end

  def icon_button(model, icon = nil)
    raise "no icon passed to icon_button" if icon.nil?

    button_tag do
      content_tag(:i, '', class: "icon-#{icon}")
    end
  end

p

  def icon_link(path, icon, **options)
    link_to(path, options) do
      content_tag(:i, '', class: "icon-#{icon}", title: options[:title]) 
    end
  end

end
