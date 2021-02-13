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

  def real_time_data
    hour_data = TblFee.hour_data(params[:sdate], params[:edate])
    game_hash = Game.partition_map
    Rails.logger.info game_hash
    tpldata = {gamename: '', "00":0, "01":0, "02":0, "03":0, "04":0, "05":0, "06":0, "07":0, "08":0, "09":0, "10":0, "11":0, "12":0, "13":0, "14":0, "15":0, "16":0, "17":0, "18":0, "19":0, "20":0, "21":0, "22":0, "23":0,
    }
    result = []
    hour_data.each do |gpar, val|
      Rails.logger.info "---------09-9: #{gpar}"
      r1 = tpldata.reverse_merge(val)
      r1[:gamename] = game_hash[gpar].gameName
      r1[:total] = val.values.reduce{|sum, it| sum+=it}
      result.push(r1)
    end
    result = result.to_json
    Rails.logger.info result

    render json: result


  end


end
