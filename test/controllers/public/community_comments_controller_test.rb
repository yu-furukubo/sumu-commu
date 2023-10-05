require "test_helper"

class Public::CommunityCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_community_comments_index_url
    assert_response :success
  end
end
