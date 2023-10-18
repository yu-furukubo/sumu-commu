module Admin::BoardsHelper
  def my_link_to(id)
    residence_search_admin_boards_path"#{id}"
  end
end
