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
        str.scan(/(\w+)%(\d+)%(\d+)/) do |chl,acc, fee|
          next if channels.kind_of?(Array) && !channels.include?(chl)
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
      tmp[:arppu1] = days_tmp['1'][:acc] > 0 ? (days_tmp['1'][:fee].to_f / days_tmp['1'][:acc]).round(2) : 0
      tmp[:arppu3] = days_tmp['3'][:acc] > 0 ? (days_tmp['3'][:fee].to_f / days_tmp['3'][:acc]).round(2) : 0
      tmp[:arppu7] = days_tmp['7'][:acc] > 0 ? (days_tmp['7'][:fee].to_f / days_tmp['7'][:acc]).round(2) : 0

      result.push(tmp)
    end

    render json: result
  end

  #新增账户行为分析-留存率(按账户)
  #新增账户行为分析-留存率(按设备)
  def retention_rate
    gid = params[:id]
    by = params[:by]
    channels = params[:channels]
    country = params[:country]
    sdate = Date.parse(params[:sdate])
    edate = Date.parse(params[:edate])
    if edate >= Date.today
      edate = Date.today - 1.day
    end
    #查询7日留存
    sqls = if by == "account"
             db_data = StatActivationChannelDay
             ["statdate,sum(newaccount) as total "]
           elsif by == "device"
             db_data = PipActivationModel
             ["statdate,sum(total) as total "]
           end

    (2..7).each do |it|
      col_name = "day#{it}count"
      sqls.push("sum(#{col_name}) as #{col_name}")
    end
    db_data = db_data.select(sqls.join(',')).where(gamecode: gid).by_statdate(sdate,edate).group(:statdate)

    if channels.present?
      db_data = db_data.by_channel(channels)
    end
    if country.present?
      db_data = db_data.where(country: country)
    end
    db_data = db_data.to_a

    result =(sdate..edate).map do |date|
      it = db_data.detect{|item| item.statdate == date.to_s}
      total = it&.total.to_f
      tmp = {date: date.to_s, total: total}
      (2..7).each do |idx|
        tmp["day#{idx}"] = total > 0 ? (it.send("day#{idx}count").to_f * 100 / total).round(2) : 0
      end
      tmp
    end

    Rails.logger.debug result

    render json: result
  end


  #新增账户行为分析-日参与次数
  def participation
    gid = params[:id]
    by = params[:by]
    channels = params[:channels]
    versions = params[:versions]
    sdate = Date.parse(params[:sdate])
    edate = Date.parse(params[:edate])
    if edate >= Date.today
      edate = Date.today - 1.day
    end

    #按渠道或者版本查询账户数
    #按渠道或者版本查询启动次数
    db_data1 = PipAccountDay.select("statdate,stepnum, count(1) total").by_gameid(gid).by_statdate(sdate,edate).where(state: 1).group(:statdate, :stepnum)
    if channels.present?
      db_data1 = db_data1.where(backchannel: channels)
    end
    if versions.present?
      db_data1 = db_data1.where(backversion: versions)
    end

    db_data1 = db_data1.to_a

    data_by_statdate = db_data1.group_by(&:statdate)

    result = []
    (sdate..edate).each do |date|
      vals = data_by_statdate[date.to_s] || []
      tmp = {date: date.to_s}
      total = vals.reduce(0){|sum, obj| sum += obj.total }
      tmp[:total] = total
      tmp1 = vals.group_by{|it| it.stepnum.to_i > 3 ? 4 : it.stepnum.to_i }
      (1..4).each do |idx|
        ary = tmp1[idx] || []
        sum1 = ary.reduce(0){|sum, item| sum+=item.total}
        tmp["s#{idx}"] = (total == 0 ? 0.0 : (sum1 * 100.0 / total)).round(2)
      end
      result.push(tmp)
    end

    Rails.logger.debug result

    render json: result
  end

  #新增账户行为分析-在线时长
  def online_time
    gid = params[:id]
    by = params[:by]
    channels = params[:channels]
    country = params[:country]
    sdate = Date.parse(params[:sdate])
    edate = Date.parse(params[:edate])
    if edate >= Date.today
      edate = Date.today - 1.day
    end

    #按渠道或者版本查询账户数
    #按渠道或者版本查询启动次数
    db_data1 = PipAccountDay.select("statdate,onlinetime").by_gameid(gid).by_statdate(sdate,edate).where(state: 1)
    if channels.present?
      db_data1 = db_data1.where(backchannel: channels)
    end
    if country.present?
      db_data1 = db_data1.where(backversion: country)
    end

    data_by_statdate = db_data1.group_by(&:statdate)

    result = []
    data_by_statdate.each do |key, vals|
      total = vals.length
      tmp = {date: key, total: total}
      tmp_sum = Hash.new(0)

      #1min以下个数,1~3min个数,3~5min个数,5~10min个数,10~30min个数,30min以上
      vals.each do |it|
        next if it.onlinetime.nil?
        case it.onlinetime.to_i
        when 0..60
          tmp_sum[:s1]+=1
        when 61..180
          tmp_sum[:s2]+=1
        when 181..300
          tmp_sum[:s3]+=1
        when 301..600
          tmp_sum[:s4]+=1
        when 601..1800
          tmp_sum[:s5]+=1
        else
          tmp_sum[:s6]+=1
        end
      end
      (1..6).each do |it|
        puts tmp_sum["s#{it}".intern]
        tmp["t#{it}"] = (tmp_sum["s#{it}".intern] * 100.0/total).round(2)
      end
      result.push(tmp)
    end
    Rails.logger.debug result
    render json: result
  end

  #新增账户行为分析-N日最大级别
  def max_level
    gid = params[:id]
    by = params[:by]
    channels = params[:channels]
    country = params[:country]
    sdate = Date.parse(params[:sdate])
    edate = Date.parse(params[:edate])
    if edate >= Date.today
      edate = Date.today - 1.day
    end

    #时间范围内第一日第二日第三日级别，注册后第二日才会记录level2, 第三日才会记录level3,
    data1 = PipAccountDay.select('level1, level2, level3').by_statdate(sdate,edate).by_gameid(gid).where(state: 1)

    #因为只统计前20级及大于20级的用户，把data1中大于20的都变更会21
    data1.each do |it|
      it.level1 = 21 if it.level1>20
      it.level2 = 21 if it.level2>20
      it.level3 = 21 if it.level3>20
    end

    #第1..3日账户数
    accs_1 = PipAccountDay.select(1).by_statdate(sdate,edate).by_gameid(gid).where(state: 1)
    accs_2 = PipAccountDay.select(1).by_statdate(sdate,edate - 1.day).by_gameid(gid).where(state: 1)
    accs_3 = PipAccountDay.select(1).by_statdate(sdate,edate - 2.day).by_gameid(gid).where(state: 1)

    if channels.present?
      data1 = data1.where(backchannel: channels)
      accs_1 = accs_1.where(backchannel: channels)
      accs_2 = accs_2.where(backchannel: channels)
      accs_3 = accs_3.where(backchannel: channels)
    end

    accs_1 = accs_1.count
    accs_2 = accs_2.count
    accs_3 = accs_3.count

    #如等于1表示第二日及第三日还没有记录，等于2表示第三日还没有记录，其它表示都已记录
    date_diff = Date.today - edate
    result = []
    (1..21).each do |it|
      tmp = Hash.new(0)
      tmp[:level] = it == 21 ? "#{it}级及以上" : "#{it}级"
      data1.each do |obj|
        tmp[:day1] += 1 if obj.level1 == it
        tmp[:day2] += 1 if obj.level2 == it
        tmp[:day3] += 1 if obj.level3 == it
      end
      case date_diff
      when 1
        tmp[:day1] = accs_1 == 0 ? 0.0 : (tmp[:day1]*100.0 / accs_1).round(2)
        tmp[:day2] = accs_2 == 0 ? 0.0 : (tmp[:day2]*100.0 / accs_2).round(2)
        tmp[:day3] = accs_3 == 0 ? 0.0 : (tmp[:day3]*100.0 / accs_3).round(2)
      when 2
        tmp[:day1] = accs_1 == 0 ? 0.0 : (tmp[:day1]*100.0 / accs_1).round(2)
        tmp[:day2] = accs_1 == 0 ? 0.0 : (tmp[:day2]*100.0 / accs_1).round(2)
        tmp[:day3] = accs_2 == 0 ? 0.0 : (tmp[:day3]*100.0 / accs_2).round(2)
      else
        if accs_1 == 0
          tmp[:day1] = 0.0
          tmp[:day2] = 0.0
          tmp[:day3] = 0.0
        else
          tmp[:day1] = (tmp[:day1]*100.0 / accs_1).round(2)
          tmp[:day2] = (tmp[:day2]*100.0 / accs_1).round(2)
          tmp[:day3] = (tmp[:day3]*100.0 / accs_1).round(2)
        end
      end
      result.push(tmp)
    end
    Rails.logger.debug result
    render json: result
  end
end
