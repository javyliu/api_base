require "test_helper"

class Api::V1::ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report_params = {
      report: {
        sdate: '2021-01-01',
        edate: '2021-01-03',
      }
    }
  end

  test "should get index" do
    get api_v1_reports_url(sdate: '2021-01-01', edate: '2021-01-03'),as: :json
    assert_response :success
  end
end
