class CustomFormBuilder < ActionView::Helpers::FormBuilder

  def icon_field(attribute, *args)
    options = args.extract_options!
    raise ArgumentError('You must pass an icon to an icon field!') unless options[:icon]
    @template.content_tag :section, class: 'input' do
      error = generate_error_message(@object.errors[attribute]) unless @object.errors[attribute].empty?
      field = generate_field(attribute, options)
      icon =  generate_icon(options[:icon])
      error.nil? ? field + icon : error + field + icon
   end
  end

  private

  def generate_error_message(errors)
    @template.content_tag(:label, errors[0], class: 'error')
  end

  def generate_field(attribute, options)
    case options[:type]
      when 'email'
        @template.email_field(@object_name, attribute, objectify_options(options)) 
      when 'password'
        @template.password_field(@object_name, attribute, objectify_options(options)) 
      else
        @template.text_field(@object_name, attribute, objectify_options(options)) 
    end 
  end

  def generate_icon(icon)
    @template.content_tag :aside do
      @template.content_tag :i, '', class: "icon-#{icon}"
    end
  end

end
