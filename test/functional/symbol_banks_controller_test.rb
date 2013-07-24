require 'test_helper'

class SymbolBanksControllerTest < ActionController::TestCase
  setup do
    @symbol_bank = symbol_banks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:symbol_banks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create symbol_bank" do
    assert_difference('SymbolBank.count') do
      post :create, symbol_bank: {  }
    end

    assert_redirected_to symbol_bank_path(assigns(:symbol_bank))
  end

  test "should show symbol_bank" do
    get :show, id: @symbol_bank
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @symbol_bank
    assert_response :success
  end

  test "should update symbol_bank" do
    put :update, id: @symbol_bank, symbol_bank: {  }
    assert_redirected_to symbol_bank_path(assigns(:symbol_bank))
  end

  test "should destroy symbol_bank" do
    assert_difference('SymbolBank.count', -1) do
      delete :destroy, id: @symbol_bank
    end

    assert_redirected_to symbol_banks_path
  end
end
