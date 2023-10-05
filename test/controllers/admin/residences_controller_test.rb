require "test_helper"

class Admin::ResidencesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_residences_new_url
    assert_response :success
  end
end
