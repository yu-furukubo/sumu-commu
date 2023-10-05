require "test_helper"

class Public::EquipmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_equipments_index_url
    assert_response :success
  end

  test "should get show" do
    get public_equipments_show_url
    assert_response :success
  end
end
