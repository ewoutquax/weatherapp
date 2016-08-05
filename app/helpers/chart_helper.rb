module ChartHelper
  def link_to_pill_menu(path, name)
    if current_page?(path)
      class_name = 'active'
    else
      class_name = nil
    end

    link = link_to(name, path)
    content_tag('li', link,  class: class_name)
  end
end
