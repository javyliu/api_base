module ActivityAnalyse
  extend ActiveSupport::Concern
  ########################################
  #活跃分析
  def activity_preview
    data1 = StatActiveFeeDay.select('statdate, activenum, loyalnum').where(gamecode: @gid).by_date(@sdate,@edate).group_by(&:statdate) #活跃账户数及忠诚用户数
    data2 = PipAccountDay.select('statdate,count(1) as num').where(gamecode: @gid).by_date(@sdate,@edate).group(:statdate).group_by(&:statdate) #新增账户数

    result = []
    (@sdate..@edate).each do |dt|
      date = dt.to_s(:db)
      tmp = Hash.new(0)
      tmp[:date] = date
      tmp[:act_num] = data1[date]&.first&.activenum.to_i
      tmp[:loyal_num] = data1[date]&.first&.loyalnum.to_i
      tmp[:new_num] = data2[date]&.first&.num.to_i
      if tmp[:act_num] == 0
        tmp[:new_rate] = 0.0
        tmp[:loyal_rate] = 0.0
      else
        tmp[:new_rate] = (tmp[:new_num] * 100.0 / tmp[:act_num]).round(2)
        tmp[:loyal_rate] = (tmp[:loyal_num] * 100.0 / tmp[:act_num]).round(2)
      end
      result.push(tmp)
    end
    Rails.logger.debug result

    render json: result

  end
  #活跃账户分布-渠道,操作系统，地域，分区
  #coop_type:合作模式（1注册/2下载/3分成/4联运）,   没有则为 0, 即所有
  #/api/v1/games/10/activity_by?sdate=2021-01-01&edate=2021-01-07&by=area&coop_type=4
  #注册天数
  #/api/v1/games/10/activity_by?sdate=2021-01-01&edate=2021-01-07&by=regdays
  #级别分布,可以传入指定分区以逗号分隔
  #/api/v1/games/10/activity_by?sdate=2021-01-01&edate=2021-01-07&by=level|&ps=xx
  #在线时长
  #/api/v1/games/10/activity_by?sdate=2021-01-01&edate=2021-01-07&by=online
  def activity_by
    coop_type = params[:coop_type].to_i
    by = case params[:by]
         when 'channel'
           select_cols = 'statdate, channel, sum(count) as count'
           #渠道号对应名称
           channel_map = ChannelCodeInfo.channel_map(@gid)
           channel_map = channel_map.where(balance_way: coop_type) if coop_type != 0
           channel_map = channel_map.to_a.group_by(&:code)
           data1 = PipActivegroupDay.select(select_cols)
           :channel
         when 'area'
           select_cols = 'statdate, province, sum(count) as count'
           data1 = PipActivegroupDay.select(select_cols)
           :province
         when 'sys'
           select_cols = 'statdate, system, sum(count) as count'
           data1 = PipActivegroupDay.select(select_cols)
           :system
         when 'regdays'
           select_cols = 'statdate, activedayinfo'
           data1 = StatActiveFeeDay.select(select_cols)
           con = {'当天': 0, '1周': 1..7, '2周':8..14,'3周':15..21, '4周':22..28,'4周-2月':29..60,'2月-3月':61..90,'3月-6月':91..180,'6月-1年':181..365,'1年以前':366..}
           :activedayinfo
         when 'level'
           select_cols = 'statdate, activelevel'
           data1 = PipActivelevelDay.select(select_cols)
           con = :max #表示需通过查询得到最大值
           data1 = data1.where(regionid: params[:ps].split(',')) if params[:ps]
           :activelevel
         when 'online'
           select_cols = 'statdate, loguser'
           data1 = StatAccountDay.select(select_cols)
           con = {'1min以下':0..60, '1-10min':61..600,'10-30min':601..1800, '30-60min':1801..3600,'60-90min':3601..5400,'90-120min':5401..7200,'120-180min':7201..10800,'3小时以上':10801..}
           :loguser
         end
    data1 = data1.by_gameid(@gid).by_date(@sdate,@edate).group(by, :statdate).to_a
    data1 = data1.group_by(&by) unless con

    result = []
    days = (@sdate..@edate).to_a

    if con
      data1 = data1.group_by(&:statdate)
      data1.each do |key, vals|
        val = vals.map(&by).join(';').scan(/(\d*)%(\d*)/).map{|v1,v2| count_time ? [v2.to_i, 1] : [v1.to_i, v2.to_i]}
        data1[key] = val
      end
      if con == :max
        max = data1.values.flatten[(0..).step(2)].max
        con = {}
        (1..max).each{|it| con["#{it}级"] = it}
      end
      con.each do |key, _range|
        tmp = {}
        tmp[params[:by]] = key
        total = 0
        days.each do |dt|
          date = dt.to_s(:db)
          its = data1[date] || []
          num = 0
          its.each { |_v1, _v2| num += _v2 if _range ===_v1 }
          total += num
          tmp[date] = num
        end
        tmp[:avg] = count_time ? total : total/days.length
        result.push(tmp)
      end
    else
      data1.each do |key,objs|
        next if by == :channel && !channel_map.include?(key) && coop_type != 0
        tmp = {}
        tmp[params[:by]] = key
        if by == :channel
          chl_model = channel_map[key]&.first
          tmp[:chl_name] = chl_model&.channel || '非确认渠道'
          tmp[:coop_type] = ChannelCodeInfo::CoopType[coop_type] || ChannelCodeInfo::CoopType[chl_model&.balance_way.to_i]
        end
        total = 0
        zero_len = 0
        vals = objs.group_by(&:statdate)
        days.each do |dt|
          date = dt.to_s(:db)
          _count = vals[date]&.first&.count.to_i
          tmp[date] = _count
          total += _count
          zero_len += 1 if _count == 0
        end

        divisor = days.length - zero_len
        tmp[:avg] = divisor == 0 ? 0 : total / divisor
        result.push(tmp)
      end
    end

    Rails.logger.debug result
    render json: result
  end

  #分时数据
  #分区用逗号分隔 ps
  def activity_hour
    data1 = StatIncomefeeHour.select('right(datehour,2) datehour,fee').by_date(@sdate,@edate).by_gameid(@gid)
    data2 = StatUserDay.by_date(@sdate,@edate).by_gameid(@gid)
    if params[:ps].present?
      partitions = params[:ps].split(',')
      data1 = data1.where(regionid: partitions)
      data2 = data2.where(gameregion: partitions)
    end
    data1 = data1.group_by(&:datehour)
    data2 = data2.pluck(:pointtimeonline).join(';').scan(/([0-9\-时]+)%(\d+)/).group_by{|it| it.first}
    result = []
    len = (@edate - @sdate + 1).to_i
    data2.each do |key,vals|
      tmp = {hour: key}
      tmp[:avg] = vals.reduce(0){|sum, it| sum+=it[1].to_i}/len
      _key = key[/\d+/].rjust(2,'0')
      tmp[:fee] = data1[_key]&.reduce(0){|sum,it| sum+=it.fee}.to_i
      result.push(tmp)
    end

    Rails.logger.debug result
    render json: result

  end

  #在线数据
  def online_data
    data1 = StatUserDay.select('statdate,pointtimeonline,highonlinenum').by_date(@sdate,@edate).by_gameid(@gid).group_by(&:statdate)
    result = []
    days = (@sdate..@edate).to_a
    days.each do |dt|
      date = dt.to_s(:db)
      tmp = Hash.new(0)
      tmp[:date] = date
      objs = data1[date] || []
      tmp[:acu] = objs.reduce(0){|sum,obj|sum += obj.cal_average}
      tmp[:pcu] = objs.map(&:highonlinenum).sum
      result.push(tmp)
    end
    render json: result
  end

  #平均在线走势-分区
  def avg_online_data
    data1 = StatUserDay.select('statdate,gameregion,pointtimeonline').by_date(@sdate,@edate).by_gameid(@gid)
    if params[:ps].present?
      partitions = params[:ps].split(',')
      data1 = data1.where(gameregion: partitions)
    end
    data1 = data1.group_by(&:statdate)
    result = []
    days = (@sdate..@edate).to_a
    pars = data1.values.flatten.map(&:gameregion).uniq.sort
    days.each do |dt|
      date = dt.to_s(:db)
      tmp = Hash.new(0)
      tmp[:date] = date
      objs = (data1[date] || []).group_by(&:gameregion)
      total = 0
      pars.each do |par|
        tmp[par] = objs[par].reduce(0){|sum,obj| sum+=obj.cal_average}
        total += tmp[par]
      end
      tmp[:total] = total
      result.push(tmp)
    end
    render json: result
  end

  #最高在线走势-分区
  def high_online_data
    data1 = StatUserDay.select('statdate,gameregion,highonlinenum').by_date(@sdate,@edate).by_gameid(@gid)
    if params[:ps].present?
      partitions = params[:ps].split(',')
      data1 = data1.where(gameregion: partitions)
    end
    data1 = data1.group_by(&:statdate)
    result = []
    days = (@sdate..@edate).to_a
    pars = data1.values.flatten.map(&:gameregion).uniq.sort
    days.each do |dt|
      date = dt.to_s(:db)
      tmp = Hash.new(0)
      tmp[:date] = date
      objs = (data1[date] || []).group_by(&:gameregion)
      total = 0
      pars.each do |par|
        tmp[par] = objs[par].reduce(0){|sum,obj| sum+=obj.highonlinenum}
        total += tmp[par]
      end
      tmp[:total] = total
      result.push(tmp)
    end
    render json: result
  end

end
