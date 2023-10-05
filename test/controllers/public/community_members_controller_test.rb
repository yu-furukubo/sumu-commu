require "test_helper"

class Public::CommunityMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_community_members_index_url
    assert_response :success
  end
end
