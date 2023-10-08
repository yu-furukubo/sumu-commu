require "test_helper"

class Admin::CircularMemberControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_circular_member_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_circular_member_new_url
    assert_response :success
  end
end
