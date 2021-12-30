class Api::V1::AppSettingController < ApplicationController
  def index
    setting = {
      "p_color": "0xFFc5e5f3",
      "bg_color": "0xFF69c5df",
      "btn_color": "0xFFfbc33e",
      "sec_bg_coor": "0xFFebf8fd",
      "p1_color": "0xFF3b3f42",
      "p2_color": "0xffcccccc"
    }

    render json: setting
  end
end
