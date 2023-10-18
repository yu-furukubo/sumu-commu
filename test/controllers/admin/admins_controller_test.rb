require "test_helper"

class Admin::AdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_admins_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_admins_edit_url
    assert_response :success
  end
end
