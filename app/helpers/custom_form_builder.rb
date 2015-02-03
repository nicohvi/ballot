class CustomFormBuilder < ActionView::Helpers::FormBuilder

  def icon_field(attribute, *args)
    options = args.extract_options!
    raise ArgumentError('You must pass an icon to an icon field!') unless options[:icon]
    @template.content_tag :section, class: 'js-input input-container' do
      error = generate_error_message(@object.errors[attribute]) unless @object.errors[attribute].empty?
      field = generate_field(attribute, options)
      icon =  generate_icon(options[:icon])
      result = error.nil? ? '' : error
      (options[:before] ? result + icon + field : result + field + icon).html_safe
   end
  end

  def label_field(attribute, *args)
    options = args.extract_options!
    @template.content_tag :section, class: 'js-input input-container' do
      @template.label(@object_name, attribute, options.delete(:label)) + generate_field(attribute, options)
    end
  end

  def submit_button(text, *args)
    options = args.extract_options!
    @template.content_tag :section, class: 'input-container' do
      @template.content_tag :button, type: :submit do
        @template.content_tag(:i, '', class: "icon-#{options[:icon]}") +
        @template.content_tag(:span, text)  
      end
    end
  end

  private

  def generate_error_message(errors)
    @template.content_tag(:label, errors[0].html_safe, class: 'error')
  end

  def generate_field(attribute, options)
    @template.send(options.delete(:type).to_sym, @object_name, attribute, objectify_options(options))
  end

  def generate_icon(icon)
    @template.content_tag :aside do
      @template.content_tag :i, '', class: "icon-#{icon}"
    end
  end

end
