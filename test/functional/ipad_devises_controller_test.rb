require 'test_helper'

class IpadDevisesControllerTest < ActionController::TestCase
  setup do
    @ipad_devise = ipad_devises(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ipad_devises)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ipad_devise" do
    assert_difference('IpadDevise.count') do
      post :create, ipad_devise: {  }
    end

    assert_redirected_to ipad_devise_path(assigns(:ipad_devise))
  end

  test "should show ipad_devise" do
    get :show, id: @ipad_devise
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ipad_devise
    assert_response :success
  end

  test "should update ipad_devise" do
    put :update, id: @ipad_devise, ipad_devise: {  }
    assert_redirected_to ipad_devise_path(assigns(:ipad_devise))
  end

  test "should destroy ipad_devise" do
    assert_difference('IpadDevise.count', -1) do
      delete :destroy, id: @ipad_devise
    end

    assert_redirected_to ipad_devises_path
  end
end
