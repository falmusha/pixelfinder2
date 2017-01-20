module ApplicationHelper

  def is_home_page?
    current_page?(controller: :main, action: :index)
  end

end
