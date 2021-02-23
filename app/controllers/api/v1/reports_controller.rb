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
      val.reverse_merge!(StatIncome3Day::InComeTpl)
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

    data.each do |key,val|
      val.reverse_merge!(StatIncome3Day::InComeTpl)
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


  #单产品实时数据
  #params id: 游戏id, cate: [reg_account:新增设备数走势,reg_channel: 新增设备渠道走势, income: 收入走势 ,income_channel: 收入渠道 active: 活跃用户, online:在线人数]

  def time_data
    cate = params[:cate]
    gid = params[:id]
    sdate = params[:sdate]
    edate = params[:edate]


    result = case cate
             when "reg_account"
               by = :time
               TblRealtimereg.data(sdate,edate, gid, group_att: :time)
             when "reg_channel"
               by = :channel
               TblRealtimereg.data(sdate,edate, gid, group_att: :channel)
             when "income"
               by = :time
               TblRealtimefee.data(sdate,edate, gid, group_att: :time)
             when "income_channel"
               by = :channel
               TblRealtimefee.data(sdate,edate, gid, group_att: :channel)
             when "active"
               TblRealtimeactive.data(sdate,edate, gid)
             when "online"
               TblRealtimeonline.data(sdate,edate, gid)
             end

    if by == :time
      missing_keys = StatIncome3Day::TimeTpl.keys - result.keys
      Rails.logger.info "-------missing_keys-------"
      Rails.logger.info missing_keys
      missing_keys.each do |item|
        result[item] = {'time'=> item }
      end
    elsif by == :channel
      channel_map = ChannelCodeInfo.channel_map(gid).group_by(&:code)
      result.each do |key,val|
        val["name"] = channel_map[key].first.try(:channel)
      end
    end


    render json: result.sort.map(&:last)

  end



end
