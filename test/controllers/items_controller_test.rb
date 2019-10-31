require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
    @user = users(:user_one)
  end

  test "should get index" do
    get items_url
    assert_response :success
  end

  test "should get new" do
    get new_item_url
    assert_response :success
  end

  test "should create item" do
    login_as_test
    assert_difference('Item.count') do
      post items_url, params: { item: { category: @item.category, name: @item.name, user_id: @item.user_id } }
    end

    assert_redirected_to item_url(Item.last)
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should get edit" do
    login_as_test
    get edit_item_url(@item)
    assert_response :success
  end

  test "should update item" do
    login_as_test
    patch item_url(@item), params: { item: { category: @item.category, name: @item.name, user_id: @item.user_id } }
    assert_redirected_to item_url(@item)
  end

  test "should destroy item" do
    login_as_test
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
