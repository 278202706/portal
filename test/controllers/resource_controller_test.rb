require 'test_helper'

class ResourceControllerTest < ActionController::TestCase
  test "should get dashboard" do
    get :dashboard
    assert_response :success
  end

  test "should get software" do
    get :software
    assert_response :success
  end

  test "should get virtualmac" do
    get :virtualmac
    assert_response :success
  end

  test "should get network" do
    get :network
    assert_response :success
  end

end
