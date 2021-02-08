class Api::V1::ReportsController < ApplicationController
  def index
    gids = params[:gids] && params[:gids].split(',') || Game.all_gids(params[:sdate])
    data1 = StatIncome3Day.get_income(params[:sdate], params[:edate], gids)
    data2 = StatUserDay.get_max_and_avg_online(params[:sdate], params[:edate], gids)
    data3 = PipAccountDay.get_new_players(params[:sdate], params[:edate], gids)
    data4 = StatActiveFeeDay.get_fee_active(params[:sdate], params[:edate], gids)


    data = data1.deep_merge(data2).deep_merge(data3).deep_merge(data4)

    render json: data
  end


end
