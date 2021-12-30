require "test_helper"

class Api::V1::AppSettingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_app_setting_index_url
    assert_response :success
  end
end
