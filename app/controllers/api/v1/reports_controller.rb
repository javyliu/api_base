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

    tpl = {"amount":0,"amount2":0,"highonlinenum":0,"avgonlinenum":0,"reguser":0}

    game_map = Game.partition_map(group_att: :gameId)

    data.each do |key,val|
      val['game_name'] = game_map[key].try(:gameName)
      val.reverse_merge!(tpl)
    end

    render json: data.values
  end

  #某个游戏总体数据一览
  def show
    data1 = StatIncome3Day.get_income(params[:sdate], params[:edate], params[:id], by_date: true)
    Rails.logger.info "-----------"
    Rails.logger.info data1
    data2 = StatUserDay.get_max_and_avg_online(params[:sdate], params[:edate],  params[:id], by_date: true)
    Rails.logger.info data2
    data3 = PipAccountDay.get_new_players(params[:sdate], params[:edate], params[:id], by_date: true)
    Rails.logger.info data3
    data4 = StatActiveFeeDay.get_fee_active(params[:sdate], params[:edate], params[:id], by_date: true)
    Rails.logger.info data4


    data = data1.deep_merge(data2).deep_merge(data3).deep_merge(data4)

    tpl = {"amount":0,"amount2":0,"highonlinenum":0,"avgonlinenum":0,"reguser":0}


    data.each do |key,val|
      val.reverse_merge!(tpl)
    end

    render json: data.values



  end

  def real_time_data
    hour_data = TblFee.hour_data(params[:sdate], params[:edate])
    game_hash = Game.partition_map
    tpldata = {'00':0, '01':0, '02':0, '03':0, '04':0, '05':0, '06':0, '07':0, '08':0, '09':0, '10':0, '11':0, '12':0, '13':0, '14':0, '15':0, '16':0, '17':0, '18':0, '19':0, '20':0, '21':0, '22':0, '23':0 }.stringify_keys

    hour_data.each do |gpar, val|
      r1 = {}.merge(tpldata,val)
      r1['gamename'] = game_hash[gpar].gameName
      r1['total'] = val.values.reduce{|sum, it| sum+=it}
      hour_data[gpar] = r1
    end
    render json: hour_data.values


  end


end
