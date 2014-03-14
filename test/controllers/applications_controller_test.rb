require 'test_helper'

class ApplicationsControllerTest < ActionController::TestCase
  test "should get dashboard" do
    get :dashboard
    assert_response :success
  end

  test "should get manage" do
    get :manage
    assert_response :success
  end

  test "should get service" do
    get :service
    assert_response :success
  end

end
