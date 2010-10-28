require 'test_helper'

class MerchesControllerTest < ActionController::TestCase
  setup do
    @merch = merches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:merches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create merch" do
    assert_difference('Merch.count') do
      post :create, :merch => @merch.attributes
    end

    assert_redirected_to merch_path(assigns(:merch))
  end

  test "should show merch" do
    get :show, :id => @merch.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @merch.to_param
    assert_response :success
  end

  test "should update merch" do
    put :update, :id => @merch.to_param, :merch => @merch.attributes
    assert_redirected_to merch_path(assigns(:merch))
  end

  test "should destroy merch" do
    assert_difference('Merch.count', -1) do
      delete :destroy, :id => @merch.to_param
    end

    assert_redirected_to merches_path
  end
end
