require "test_helper"

class Public::FacilitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_facilities_index_url
    assert_response :success
  end

  test "should get show" do
    get public_facilities_show_url
    assert_response :success
  end
end
