module ApplicationHelper
  def active_link_to(path, name)
    class_name = (current_controller?(path)) ? 'active' : nil
    link       = link_to(name, path)

    content_tag('li', link, class: class_name)
  end

  def current_controller?(path)
    controller_name == Rails.application.routes.recognize_path(path)[:controller]
  end
end
