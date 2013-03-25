module BootstrapHelper
  def icon(show_icon, icon_true, icon_false = nil)
    return if icon_false.nil? && !show_icon
    opts = {}
    opts[:class] = show_icon ? "fa fa-#{icon_true}" : "fa fa-#{icon_false}"
    content_tag(:i, '', opts)
  end

  def flash_class(level)
    case level
    when :notice then 'alert-info'
    when :success then 'alert-success'
    when :error then 'alert-danger'
    when :alert then 'alert-danger'
    else level.to_s
    end
  end
end
