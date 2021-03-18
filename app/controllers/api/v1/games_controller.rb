class Api::V1::GamesController < ApplicationController
  before_action :game_params, except: [:index]
  include NewUserAnalyse
  include PayAnalyse
  include ActivityAnalyse
  include LostAnalyse
  include BuyAnalyse
  include SyntheticAnalyse

  #返回所有游戏列表
  def index
    data = Hash[Game.pluck(:gameid, :gamename)]
    Rails.logger.info data.inspect
    render json: data
  end

  #某个游戏总体数据一览
  def show
    data1 = StatIncome3Day.get_income(@sdate,@edate,@gid, with_date: true)
    Rails.logger.info "-----------"
    Rails.logger.info data1
    data2 = StatUserDay.get_max_and_avg_online(@sdate,@edate,@gid, with_date: true)
    Rails.logger.info data2
    data3 = PipAccountDay.get_new_players(@sdate,@edate,@gid, with_date: true)
    Rails.logger.info data3
    data4 = StatActiveFeeDay.get_fee_active(@sdate,@edate,@gid, with_date: true)
    Rails.logger.info data4

    data = data1.deep_merge(data2).deep_merge(data3).deep_merge(data4)
    render json: data.values
  end

  #单产品实时数据
  #params id: 游戏id, cate: [reg_account:新增设备数走势,reg_channel: 新增设备渠道走势, income: 收入走势 ,income_channel: 收入渠道 active: 活跃用户, online:在线人数]
  def time_data
    cate = params[:cate]
    result = case cate
             when "reg_account"
               by = :time
               TblRealtimereg.data(@sdate,@edate, @gid, group_att: :time)
             when "reg_channel"
               by = :channel
               TblRealtimereg.data(@sdate,@edate, @gid, group_att: :channel)
             when "income"
               by = :time
               TblRealtimefee.data(@sdate,@edate, @gid, group_att: :time)
             when "income_channel"
               by = :channel
               TblRealtimefee.data(@sdate,@edate, @gid, group_att: :channel)
             when "active"
               TblRealtimeactive.data(@sdate,@edate, @gid)
             when "online"
               TblRealtimeonline.data(@sdate,@edate, @gid)
             end

    if by == :channel
      channel_map = ChannelCodeInfo.channel_map(@gid).group_by(&:code)
      result.each do |key,val|
        val["name"] = channel_map[key].first.try(:channel)
      end
    end
    render json: result.sort.map(&:last)
  end












  private
  def game_params
    @sdate = Date.parse(params[:sdate])
    if params[:edate]

      @edate = Date.parse(params[:edate])
      if @edate >= Date.today
        @edate = Date.today - 1.day
      end
    end
    @gid = params[:id]

  end

end
