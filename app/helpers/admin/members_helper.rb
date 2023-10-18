module Admin::MembersHelper
  def my_link_to(id)
    residence_search_admin_members_path"#{id}"
  end
end
