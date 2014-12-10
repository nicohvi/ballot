module ApplicationHelper

  def poll_title(**opts)
    content_tag(:section, class: 'poll-title') do
      content_tag(:i, '', class: 'fa fa-bar-chart fa-3x') + content_tag(:h1, @poll.name) +
      if opts[:edit]
        content_tag(:section, class: 'form') do
          form_for(@poll, remote: true) do |f|
              f.text_field :name
          end
        end + content_tag(:i, '', class:'fa fa-pencil fa-2x small') 
      end
    end
  end

  def paginate(collection, options)
    options.merge!({ previous_label: '←', next_label: '→' })
    will_paginate(collection, options)
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
