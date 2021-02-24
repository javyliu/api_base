class Api::V1::ReportsController < ApplicationController
  #总体数据
  def index
    gids = params[:gids] && params[:gids].split(',') || Game.all_gids(params[:sdate])
    data1 = StatIncome3Day.get_income(params[:sdate], params[:edate], gids)
    Rails.logger.info "-----------"
    Rails.logger.info data1
    data2 = StatUserDay.get_max_and_avg_online(params[:sdate], params[:edate], gids)
    Rails.logger.info data2
    data3 = PipAccountDay.get_new_players(params[:sdate], params[:edate], gids)
    Rails.logger.info data3
    data4 = StatActiveFeeDay.get_fee_active(params[:sdate], params[:edate], gids)
    Rails.logger.info data4


    data = data1.deep_merge(data2).deep_merge(data3).deep_merge(data4)


    game_map = Game.partition_map(group_att: :gameId)

    data.each do |key,val|
      val['game_name'] = game_map[key].try(:gameName)
      #val.reverse_merge!(StatIncome3Day::InComeTpl)
    end

    render json: data.values
  end


  #所有产品实时收入
  def real_time_data
    hour_data = TblFee.hour_data(params[:sdate], params[:edate])
    game_hash = Game.partition_map

    hour_data.each do |gpar, val|
      r1 = {}.merge(StatIncome3Day::TimeTpl,val)
      r1['gamename'] = game_hash[gpar].gameName
      r1['total'] = val.values.reduce{|sum, it| sum+=it}
      hour_data[gpar] = r1
    end
    render json: hour_data.values
  end



end
