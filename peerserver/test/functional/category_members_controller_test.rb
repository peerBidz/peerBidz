require 'test_helper'

class CategoryMembersControllerTest < ActionController::TestCase
  setup do
    @category_member = category_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:category_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create category_member" do
    assert_difference('CategoryMember.count') do
      post :create, category_member: @category_member.attributes
    end

    assert_redirected_to category_member_path(assigns(:category_member))
  end

  test "should show category_member" do
    get :show, id: @category_member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @category_member
    assert_response :success
  end

  test "should update category_member" do
    put :update, id: @category_member, category_member: @category_member.attributes
    assert_redirected_to category_member_path(assigns(:category_member))
  end

  test "should destroy category_member" do
    assert_difference('CategoryMember.count', -1) do
      delete :destroy, id: @category_member
    end

    assert_redirected_to category_members_path
  end
end
