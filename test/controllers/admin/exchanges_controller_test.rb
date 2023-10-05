require "test_helper"

class Admin::ExchangesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_exchanges_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_exchanges_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_exchanges_edit_url
    assert_response :success
  end
end
