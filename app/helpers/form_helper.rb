module FormHelper

  def icon_button(model, icon = nil)
    raise "no icon passed to icon_button" if icon.nil?

    button_tag do
      content_tag(:i, '', class: "fa fa-#{icon} fa-2x")
    end
  end

end
