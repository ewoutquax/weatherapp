module ChartHelper
  def link_to_pill_menu(path, name)
    class_name = (current_page?(path)) ? 'active' : nil
    link       = link_to(name, path)

    content_tag('li', link, class: class_name)
  end
end
