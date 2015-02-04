module ApplicationHelper

  def paginate(collection, options={})
    options.merge!({ previous_label: 'Prev', next_label: 'Next' })
    will_paginate(collection, options)
  end

  def custom_form_for(name, *args, &block)
    options = args.extract_options!
    form_for(name, options.merge({builder: CustomFormBuilder}), &block)
  end 

  def conditional_length(count, term)
    count == 1 ? term.singularize : term.pluralize 
  end

end
