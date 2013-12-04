require 'test_helper'

class BlackjackControllerTest < ActionController::TestCase
  test "should get new_game" do
    get :new_game
    assert_response :success
  end

  test "should get create_game" do
    get :create_game
    assert_response :success
  end

  test "should get join_game" do
    get :join_game
    assert_response :success
  end

end
