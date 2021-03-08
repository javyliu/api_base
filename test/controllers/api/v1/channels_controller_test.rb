require "test_helper"

class Api::V1::ChannelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_channels_index_url
    assert_response :success
  end
end
