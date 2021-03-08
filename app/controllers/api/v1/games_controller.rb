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
    coop_type = params[:coop_type].to_i
    cate = (params[:cate] || 1).to_i
    gid = params[:id]
    sdate = params[:sdate]
    edate = params[:edate]

    #渠道号对应名称
    channel_map = ChannelCodeInfo.channel_map(gid)
    channel_map = channel_map.where(balance_way: coop_type) if coop_type != 0
    channel_map = channel_map.to_a.group_by(&:code)

    days_ary = (sdate..edate).to_a
    case cate
    when 1
      #新增注册数
      num_hash = StatAccountDay.channel_registed_users(sdate, edate,gid)
      channel_codes = num_hash.values.map{|item| item.keys}.flatten.uniq
    when 2
      #新增激活数
      num_hash = StatActivationChannelDay.select('statdate, chlcode, sum(total) as activated_num').where(gamecode: gid).by_statdate(sdate,edate).group(:chlcode, :statdate).group_by(&:statdate)
      channel_codes = Set[]
      num_hash.each do |k,vals|
        num_hash[k] = vals.reduce(Hash.new(0)) do |sit, it|
          channel_codes.add(it.chlcode)
          sit[it.chlcode] = it.activated_num
          sit
        end
      end
    when 3
      #新增账户数
      num_hash = PipAccountDay.select('statdate,backchannel,count(1) as num').by_gameid(gid).by_statdate(sdate,edate).where(state: 1).group(:backchannel, :statdate).group_by(&:statdate)
      channel_codes = Set[]
      num_hash.each do |k,vals|
        num_hash[k] = vals.reduce(Hash.new(0)) do |sit, it|
          channel_codes.add(it.backchannel)
          sit[it.backchannel] = it.num
          sit
        end
      end
    end

    result = []
    channel_codes.each do |code|
      next if !channel_map.include?(code) && coop_type != 0

      chl_model = channel_map[code].first

      tmp_h = Hash.new(0)
      tmp_h[:chl] = code
      tmp_h[:chl_name] = chl_model&.channel || '非确认渠道'
      tmp_h[:coop_type] = ChannelCodeInfo::CoopType[coop_type] || ChannelCodeInfo::CoopType[chl_model.balance_way.to_i]
      tmp_h[:total] = days_ary.reduce(0) do |sum,date_col|
        tmp_h[date_col] = num_hash.dig(date_col, code)
        sum += tmp_h[date_col]
      end
      result.push(tmp_h)
    end

    render json: result

  end

  #新增账户综合数据, 返回 累计付费率，累计ARPU, 留存率
  def synthetic_data
    gid = params[:id]
    channels = params[:channels]
    country = params[:country]
    sdate = Date.parse(params[:sdate])
    edate = Date.parse(params[:edate])
    if edate >= Date.today
      edate = Date.today - 1.day
    end

    #账户综合数据
    data1 = StatUseractiveDay.select("statdate, days30channelfee").where(gameswitch: gid).by_statdate(sdate,edate)
    #留在率及登录账户数
    #查询7日留存
    sqls = ["sum(newaccount) as day1count"]
    (2..30).each do |it|
      col_name = "day#{it}count"
      sqls.push("sum(#{col_name}) as #{col_name}")
    end
    day_accounts = StatActivationChannelDay.select(sqls.join(',')).where(gamecode: gid).by_statdate(sdate,edate)
    days_sum = StatActivationChannelDay.select('statdate,sum(newaccount) as newaccount').where(gamecode: gid).by_statdate(sdate,edate).group(:statdate)
    if channels.present?
      day_accounts = day_accounts.where(chlcode: channels)
      days_sum = days_sum.where(chlcode: channels)
    end
    if country.present?
      day_accounts = day_accounts.where(country: country)
      days_sum = days_sum.where(country: country)
    end
    day_accounts = day_accounts.first
    days_sum = days_sum.group_by(&:statdate)

    #['2021-01-01','2021-01-02'...]
    select_days = (sdate..edate).map(&:to_s)

    Rails.logger.debug "-----------------------"

    #['2021-01-01','2021-01-02'...]
    check_days = (sdate...Date.today).map(&:to_s)

    #新增账户数
    day_vals = select_days.map{|it| days_sum[it]&.first&.newaccount || 0 }

    #下一天的数注数为下一天的注册数加上前一天的注册数
    ary = []
    day_vals.each_with_index do |it,idx|
      ary.push(ary[idx-1].to_i + it)
    end

    if check_days.length - select_days.length > 0
      ary.push(*(Array.new(check_days.length - select_days.length, ary.last)))
    end
    ary.reverse!


    result = {}
    #把每天每个渠道的注册数及充值数加起来得到这段时间第一天到第记录天数的新增账户数及充值数
    #{1:{acc: xx, fee: xx}, 2: {acc: xx, fee: xx},...}
    data1.to_a.each do |it|
      it.days30channelfee.scan(/(\d+):([\w%;]*)/) do |day,str|
        result[day] = Hash.new(0) unless result[day]
        str.scan(/%(\d+)%(\d+)/) do |acc, fee|
          result[day][:acc] += acc.to_i
          result[day][:fee] += fee.to_i/100
        end
      end
    end

    result.each do |key, val|
      val[:login] = day_accounts.send("day#{key}count")
      val[:total] = ary[key.to_i - 1]
    end

    Rails.logger.debug result
    return_data = {}

    result.keys.each do |key,val|
      tmp = {}
      val = result[key]
      tmp[:fufeili] = val[:total] = 0 ? 0 : (val[:acc]*100.0 / val[:total]).round(2)
      tmp[:arpu] =  val[:total] = 0 ? 0 : (val[:fee] * 1.0 / val[:total]).round(2)
      tmp[:liuchun] =  val[:total] = 0 ? 0 : (val[:login] * 100.0 / val[:total]).round(2)
      return_data[key] = tmp
    end

    Rails.logger.debug  "resunt_data: #{return_data}"

    render json: return_data
  end

  #新增账户行为分析-付费
  def new_account_behavior
    gid = params[:id]
    channels = params[:channels]
    country = params[:country]
    sdate = Date.parse(params[:sdate])
    edate = Date.parse(params[:edate])
    if edate >= Date.today
      edate = Date.today - 1.day
    end
    #账户综合数据
    data1 = StatUseractiveDay.select("statdate, days30channelfee").where(gameswitch: gid).by_statdate(sdate,edate)
    if country.present?
      data1 = data1.where(country: country)
    end

    days_sum = StatActivationChannelDay.select('statdate,sum(newaccount) as newaccount').where(gamecode: gid).by_statdate(sdate,edate).group(:statdate)
    if channels.present?
      days_sum = days_sum.where(chlcode: channels)
    end
    if country.present?
      days_sum = days_sum.where(country: country)
    end
    days_sum = days_sum.group_by(&:statdate)

    result = []
    #把每天每个渠道的注册数及充值数加起来得到这段时间第一天到第记录天数的新增账户数及充值数
    #{1:{acc: xx, fee: xx}, 2: {acc: xx, fee: xx},...}
    data1.to_a.each do |it|
      acc_num = days_sum[it.statdate]&.first&.newaccount || 0
      tmp = {date: it.statdate, acc_num: acc_num}
      days_tmp = {}
      it.days30channelfee.scan(/(\d+):([\w%;]*)/) do |day,str|
        days_tmp[day] = Hash.new(0) unless days_tmp[day]
        str.scan(/%(\d+)%(\d+)/) do |acc, fee|
          days_tmp[day][:acc] += acc.to_i
          days_tmp[day][:fee] += fee.to_i/100
        end
      end
      tmp[:num1] = acc_num > 0 ? (days_tmp['1'].try(:[],:acc).to_i * 100.0 / acc_num).round(2) : 0
      tmp[:num3] = acc_num > 0 ? (days_tmp['3'].try(:[],:acc).to_i * 100.0 / acc_num).round(2) : 0
      tmp[:num7] = acc_num > 0 ? (days_tmp['7'].try(:[],:acc).to_i * 100.0 / acc_num).round(2) : 0
      tmp[:arpu1] = acc_num > 0 ? (days_tmp['1'].try(:[],:fee).to_f  / acc_num).round(2) : 0
      tmp[:arpu3] = acc_num > 0 ? (days_tmp['3'].try(:[],:fee).to_f  / acc_num).round(2) : 0
      tmp[:arpu7] = acc_num > 0 ? (days_tmp['7'].try(:[],:fee).to_f  / acc_num).round(2) : 0
      tmp[:arppu1] = (days_tmp['1'][:fee].to_f / days_tmp['1'][:acc]).round(2) rescue 0
      tmp[:arppu3] = (days_tmp['3'][:fee].to_f / days_tmp['3'][:acc]).round(2) rescue 0
      tmp[:arppu7] = (days_tmp['7'][:fee].to_f / days_tmp['7'][:acc]).round(2) rescue 0

      result.push(tmp)
    end

    Rails.logger.debug result

  end

end
