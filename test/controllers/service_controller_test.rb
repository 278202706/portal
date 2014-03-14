require 'test_helper'

class ServiceControllerTest < ActionController::TestCase
  test "should get market" do
    get :market
    assert_response :success
  end

  test "should get applylist" do
    get :applylist
    assert_response :success
  end

  test "should get manage" do
    get :manage
    assert_response :success
  end

end
