require "test_helper"

class Public::ExchangesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_exchanges_index_url
    assert_response :success
  end

  test "should get show" do
    get public_exchanges_show_url
    assert_response :success
  end

  test "should get new" do
    get public_exchanges_new_url
    assert_response :success
  end

  test "should get edit" do
    get public_exchanges_edit_url
    assert_response :success
  end
end
