require "test_helper"

class Api::V1::ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do


  end

  test "should get index" do
    get api_v1_reports_url
    assert_response :success
  end
end
