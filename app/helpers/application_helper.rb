module ApplicationHelper

  def poll_title(**opts)
    content_tag(:section, class: 'poll-title') do
      content_tag(:h1, @poll.name) +
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
    options.merge!({ previous_label: 'Prev', next_label: 'Next' })
    will_paginate(collection, options)
  end

  def custom_form_for(name, *args, &block)
    options = args.extract_options!
    form_for(name, options.merge({builder: CustomFormBuilder}), &block)
  end 

end
