require "test_helper"

class Public::CommunitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_communities_index_url
    assert_response :success
  end

  test "should get show" do
    get public_communities_show_url
    assert_response :success
  end

  test "should get new" do
    get public_communities_new_url
    assert_response :success
  end

  test "should get edit" do
    get public_communities_edit_url
    assert_response :success
  end
end
