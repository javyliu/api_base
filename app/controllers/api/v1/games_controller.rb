class Api::V1::GamesController < ApplicationController
  def index
    data = Hash[Game.pluck(:gameid, :gamename)]
    Rails.logger.info data.inspect
    render json: data
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

    #data.each do |key,val|
    #  val.reverse_merge!(StatIncome3Day::InComeTpl)
    #end

    render json: data.values
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

    #if by == :time
     # missing_keys = StatIncome3Day::TimeTpl.keys - result.keys
     # Rails.logger.info "-------missing_keys-------"
     # Rails.logger.info missing_keys
     # missing_keys.each do |item|
     #   result[item] = {'time'=> item }
     # end
    if by == :channel
      channel_map = ChannelCodeInfo.channel_map(gid).group_by(&:code)
      result.each do |key,val|
        val["name"] = channel_map[key].first.try(:channel)
      end
    end
    render json: result.sort.map(&:last)
  end

  #新增玩家综述
  #params: id: gameid, sdate,edate
  def summary
    data1 = PipAccountDay.get_new_players(params[:sdate], params[:edate], params[:id], by_date: true)
    data2 = StatActivationChannelDay.activated_num(params[:sdate], params[:edate], params[:id])
    data3 = StatAccountDay.registed_users(params[:sdate], params[:edate], params[:id])

    data = data1.deep_merge(data2).deep_merge(data3)
    render json: data.values
  end

  #渠道玩家走势
  #coop_type:合作模式（1注册/2下载/3分成/4联运）,   没有则为“注册”
  #cate: 1：新增注册数 2：新增激活数 3：新增账户数
  def channel_users
    coop_type = params[:coop_type]
    cate = params[:cate]
    gid = params[:id]
    sdate = params[:sdate]
    edate = params[:edate]

    #渠道号对应名称
    channel_map = ChannelCodeInfo.channel_map(gid)
    channel_map = channel_map.where(balance_wap: coop_type) if coop_type.present?
    channel_map = channel_map.group_by(&:code)

    case cate
    when 1

    when 2

    when 3

    end


  end


end
