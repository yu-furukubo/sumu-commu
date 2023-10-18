module Admin::ExchangesHelper
  def my_link_to(id)
    residence_search_admin_exchanges_path"#{id}"
  end
end
