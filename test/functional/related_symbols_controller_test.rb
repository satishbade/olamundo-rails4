require 'test_helper'

class RelatedSymbolsControllerTest < ActionController::TestCase
  setup do
    @related_symbol = related_symbols(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:related_symbols)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create related_symbol" do
    assert_difference('RelatedSymbol.count') do
      post :create, related_symbol: { symbol_text: @related_symbol.symbol_text }
    end

    assert_redirected_to related_symbol_path(assigns(:related_symbol))
  end

  test "should show related_symbol" do
    get :show, id: @related_symbol
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @related_symbol
    assert_response :success
  end

  test "should update related_symbol" do
    put :update, id: @related_symbol, related_symbol: { symbol_text: @related_symbol.symbol_text }
    assert_redirected_to related_symbol_path(assigns(:related_symbol))
  end

  test "should destroy related_symbol" do
    assert_difference('RelatedSymbol.count', -1) do
      delete :destroy, id: @related_symbol
    end

    assert_redirected_to related_symbols_path
  end
end
