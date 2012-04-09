require 'test_helper'

class SellerringsControllerTest < ActionController::TestCase
  setup do
    @sellerring = sellerrings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sellerrings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sellerring" do
    assert_difference('Sellerring.count') do
      post :create, :sellerring => @sellerring.attributes
    end

    assert_redirected_to sellerring_path(assigns(:sellerring))
  end

  test "should show sellerring" do
    get :show, :id => @sellerring.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sellerring.to_param
    assert_response :success
  end

  test "should update sellerring" do
    put :update, :id => @sellerring.to_param, :sellerring => @sellerring.attributes
    assert_redirected_to sellerring_path(assigns(:sellerring))
  end

  test "should destroy sellerring" do
    assert_difference('Sellerring.count', -1) do
      delete :destroy, :id => @sellerring.to_param
    end

    assert_redirected_to sellerrings_path
  end
end
