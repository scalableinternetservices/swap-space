require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end
  test "should get new" do
    get users_new_url
    assert_response :success
  end

end
