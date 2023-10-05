require "test_helper"

class Admin::EquipmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_equipments_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_equipments_new_url
    assert_response :success
  end

  test "should get show" do
    get admin_equipments_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_equipments_edit_url
    assert_response :success
  end
end
