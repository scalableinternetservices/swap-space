require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', passwowrd: '' }}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get '/items'
    assert flash.empty?
  end
end
