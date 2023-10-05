require "test_helper"

class Public::CircularMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_circular_members_index_url
    assert_response :success
  end
end
