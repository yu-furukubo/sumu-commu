require "test_helper"

class Public::ResidencesControllerTest < ActionDispatch::IntegrationTest
  test "should get choice" do
    get public_residences_choice_url
    assert_response :success
  end
end
