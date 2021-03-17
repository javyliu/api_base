module PayAnalyse
  extend ActiveSupport::Concern
  ###################################################
  #充值分析,付费综述
  def pay_review
    channels = params[:channels]
    country = params[:country]

    data1 = StatIncome3Day.select('statdate,sum(amount) as amount, sum(amount2) as amount2').by_date(@sdate,@edate).by_gameid(@gid).group(:statdate).group_by(&:statdate)
    data2 = StatActiveFeeDay.select('statdate, sum(feenum) feenum,  sum(activenum) activenum').by_date(@sdate,@edate).by_gameid(@gid).group(:statdate).group_by(&:statdate)

    result = []
    (@sdate..@edate).each do |dt|
      date = dt.to_s
      tmp = {date: date}
      tmp[:amount] = (data1[date]&.first&.amount.to_i/100.0).round(2)
      tmp[:amount2] = (data1[date]&.first&.amount2.to_i/100.0).round(2)
      tmp[:feenum] = data2[date]&.first&.feenum.to_i
      tmp[:activenum] = data2[date]&.first&.activenum.to_i
      tmp[:fee_rate] = tmp[:activenum] == 0 ? 0.0 : (tmp[:feenum] * 100.0 / tmp[:activenum]).round(2)
      tmp[:arpu] = tmp[:activenum] == 0 ? 0.0 : (tmp[:amount] / tmp[:activenum]).round(2)
      tmp[:arppu] = tmp[:activenum] == 0 ? 0.0 : (tmp[:amount] / tmp[:feenum]).round(2)
      result.push(tmp)
    end

    Rails.logger.debug result

    render json: result

  end

  #新老付费账户分析
  def fee_user_analyze
    #付费账户, firstcharge = 1 为新增付费账号
    data1 = StatIncomeSumDay.select('statdate, accountid, money1, firstcharge').by_date(@sdate,@edate).where(gamecode: @gid).group_by(&:statdate).to_a
    new_fee_num = {}
    data1.map do |key, vals|
      first_charge_accounts = vals.reduce([]){|sum,it|sum.push(it.accountid) if it.firstcharge == '1'; sum }

      tmp = {count: 0, money1: 0}
      vals.each do |obj|
        tmp[:money1] += obj.money1 if first_charge_accounts.include?(obj.accountid)
        tmp[:count] += 1 if obj.firstcharge == '1'
      end

      new_fee_num[key] = tmp
    end

    #分成前收入
    data2 = StatIncome3Day.select('statdate,sum(amount) as amount').by_date(@sdate,@edate).where(gamecode: @gid).group(:statdate).group_by(&:statdate)
    #付费账户数
    data3 = StatActiveFeeDay.select('statdate, sum(feenum) as feenum').by_date(@sdate,@edate).where(gamecode: @gid).group(:statdate).group_by(&:statdate)

    result = []
    (@sdate..@edate).each do |dt|
      date = dt.to_s(:db)
      tmp = {date: date}
      tmp[:amount] = (data2[date]&.first&.amount.to_i/100.0).round(2)
      tmp[:feenum] = data3[date]&.first&.feenum.to_i
      tmp[:money1] = (new_fee_num[date].try(:[],:money1).to_i/100.0).round(2)
      tmp[:newfnum] = new_fee_num[date].try(:[], :count)
      tmp[:newnrate] = (tmp[:newfnum].to_i*100.0 / tmp[:feenum]).round(2)
      tmp[:newmrate] = (tmp[:money1]*100 / tmp[:amount]).round(2)
      result.push(tmp)
    end

    Rails.logger.debug result

    render json: result
  end

  #不同时期注册账户收入贡献-付费账户数-贡献金额,stat_income_regtime_day, regtime%feenum%feemoney
  def reg_charge
    by = if params[:by] == 'num'
           :num
         else
           :fee
         end

    data1 = StatIncomeRegtimeDay.select('statdate,regtimemoney').where(gamecode: @gid).by_date(@sdate,@edate).group_by(&:statdate)
    data1.each do |key, vals|
      data1[key] = vals.first.regtimemoney.scan(/([0-9\-]+)%(\d+)%(\d+)/).map{|date, num, fee| {date_num: Date.parse(date).to_time.to_i, num: num.to_i, fee: fee.to_f/100}}
    end

    result = []
    (@sdate..@edate).each do |dt|
      date = dt.to_s(:db)
      vals = data1[date]
      tmp = Hash.new(0)
      tp = [dt.to_time.to_i, (dt-1.week).to_time.to_i,(dt-2.week).to_time.to_i,(dt-3.week).to_time.to_i,(dt-4.week).to_time.to_i,(dt-60.days).to_time.to_i,(dt-90.days).to_time.to_i,(dt-180.days).to_time.to_i,(dt-365.days).to_time.to_i ]


      total = vals.reduce(0){|sum,it| sum += it[by]}

      #时间点
      vals.each do |it|
        case it[:date_num]
        when tp[0]
          tmp[:w0] += it[by].to_i
        when tp[1]...tp[0]
          tmp[:w1] += it[by].to_i
        when tp[2]...tp[1]
          tmp[:w2] += it[by].to_i
        when tp[3]...tp[2]
          tmp[:w3] += it[by].to_i
        when tp[4]...tp[3]
          tmp[:w4] += it[by].to_i
        when tp[5]...tp[4]
          tmp[:m2] += it[by].to_i
        when tp[6]...tp[5]
          tmp[:m3] += it[by].to_i
        when tp[7]...tp[6]
          tmp[:m6] += it[by].to_i
        when tp[8]...tp[7]
          tmp[:y1] += it[by].to_i
        else
          tmp[:ym] += it[by].to_i
        end
      end

      tmp.each do |key,val|
        tmp[key] = (val*100.0 / total).round(2)
      end
      tmp[:date] = date
      tmp[:total] = total

      result.push(tmp)
    end

    Rails.logger.debug result

    render json: result
  end

  # 收入分布-渠道
  #coop_type:合作模式（1注册/2下载/3分成/4联运）, 0 为所有
  #cate: 1：分成前 2：分成后
  def income_channel
    coop_type = params[:coop_type].to_i
    cate = (params[:cate] || 1).to_i

    #渠道号对应名称
    channel_map = ChannelCodeInfo.channel_map(@gid)
    channel_map = channel_map.where(balance_way: coop_type) if coop_type != 0
    channel_map = channel_map.to_a.group_by(&:code)

    days_ary = (@sdate..@edate).to_a

    col =  cate == 1 ? 'money1' : 'money2'

    data1 = PipIncomegroupDay.select("statdate, registerchannel, sum(#{col}) as money").where(gamecode: @gid).by_date(@sdate,@edate).group(:statdate, :registerchannel).to_a
    reg_channels = data1.reduce([]){|sum, obj| sum.push(obj.registerchannel); sum}.uniq
    act_channels = PipActivegroupDay.where(gamecode: @gid).by_date(@sdate,@edate).pluck(:channel).uniq

    money_hash = data1.group_by(&:statdate)
    money_hash.each do |k,vals|
      money_hash[k] = vals.reduce(Hash.new(0)) do |sit, it|
        sit[it.registerchannel] = it.money/100.0
        sit
      end
    end

    #注册和激活渠道
    result = []
    (reg_channels | act_channels).each do |code|
      next if !channel_map.include?(code) && coop_type != 0 #非所有时展示所有
      chl_model = channel_map[code].first
      tmp_h = Hash.new(0)
      tmp_h[:chl] = code
      tmp_h[:chl_name] = chl_model&.channel || '非确认渠道'
      tmp_h[:coop_type] = ChannelCodeInfo::CoopType[coop_type] || ChannelCodeInfo::CoopType[chl_model.balance_way.to_i]
      tmp_h[:total] = days_ary.reduce(0) do |sum,date_col|
        date = date_col.to_s(:db)
        tmp_h[date] = money_hash.dig(date, code)
        sum += tmp_h[date]
      end
      result.push(tmp_h)

    end

    Rails.logger.debug result
    render json: result
  end

  #收入分布-地域
  #收入分布-支付通道
  #根据地域信息统计收入
  def income_by
    money = params[:money] == 'after' ? :money2 : :money1
    by_key = params[:by]
    by = if by_key == 'paychannel'
           :paychannel
         elsif by_key == 'sys'
           :phonesys
         elsif by_key == 'region'
           :regionid
         else
           by_key = :area
           :province
         end


    if @edate >= Date.today
      @edate = Date.today - 1.day
    end

    data1 = PipIncomegroupDay.select("statdate,#{by},sum(#{money}) as money").where(gamecode: @gid).by_date(@sdate,@edate).group(by, :statdate).to_a

    result = []
    data1.group_by(&by).each do |key, vals|
      tmp = {}
      tmp[by_key] = key
      grds = vals.group_by(&:statdate)
      total = 0
      (@sdate..@edate).each do |dt|
        date = dt.to_s(:db)
        tmp[date] = grds[date]&.first&.money.to_i/100.0
        total += tmp[date]
      end
      tmp[:total] = total.round(2)
      result.push(tmp)
    end

    Rails.logger.debug result
    render json: result
  end

  #coop_type:合作模式（1注册/2下载/3分成/4联运）, 0 为所有
  #付费渗透率-渠道 /api/v1/games/10/pay_rate_by?@sdate=2021-01-01&@edate=2021-01-07&cate=avg&coop_type=1&by=channel
  #付费渗透率-渠道 付费账户数 /api/v1/games/10/pay_rate_by?@sdate=2021-01-01&@edate=2021-01-07&cate=num&coop_type=1&by=channel
  #付费渗透率-操作系统  /api/v1/games/10/pay_rate_by?@sdate=2021-01-01&@edate=2021-01-07&cate=avg&by=sys
  #付费渗透率-操作系统 付费账户数 /api/v1/games/10/pay_rate_by?@sdate=2021-01-01&@edate=2021-01-07&cate=num&by=sys
  def pay_rate_by
    coop_type = params[:coop_type].to_i
    cate = if params[:cate] == 'avg'
            :avg
          else
            :num
          end
    select_cols = []
    by = case params[:by]
         when 'channel'
           select_cols[0] = 'statdate, registerchannel as channel, count(distinct accountid) as count'
           select_cols[1] = 'statdate, channel, sum(count) as count'
           :channel
         when 'area'
           select_cols[0] = 'statdate, province, count(distinct accountid) as count'
           select_cols[1] = 'statdate, province, sum(count) as count'
           :province
         when 'sys'
           select_cols[0] = 'statdate, phonesys, count(distinct accountid) as count'
           select_cols[1] = 'statdate, system as phonesys, sum(count) as count'
           :phonesys
         when 'partition'
           select_cols[0] = 'statdate, regionid, count(distinct accountid) as count'
           select_cols[1] = 'statdate, regionid, activelevel as count'
           :regionid
         end


    #渠道号对应名称
    if by == :channel
      channel_map = ChannelCodeInfo.channel_map(@gid)
      channel_map = channel_map.where(balance_way: coop_type) if coop_type != 0
      channel_map = channel_map.to_a.group_by(&:code)
    end

    days_ary = (@sdate..@edate).to_a

    data1 = StatIncomeSumDay.select(select_cols[0]).by_date(@sdate,@edate).where(gamecode: @gid).group(by, :statdate).to_a
    data2 = if by == :regionid
              PipActivelevelDay.select(select_cols[1]).by_date(@sdate,@edate).where(gamecode: @gid).each do |obj|
                obj.count = obj.count.scan(/%(\d+)/).flatten.map(&:to_i).sum
              end
            else
              PipActivegroupDay.select(select_cols[1]).by_date(@sdate,@edate).where(gamecode: @gid).group(by, :statdate).to_a
            end


    reg_map = data1.map(&by).uniq
    act_map = data2.map(&by).uniq

    pay_num = data1.group_by(&:statdate)
    pay_num.each do |key,vals|
      pay_num[key] = vals.group_by(&by)
    end
    act_num = data2.group_by(&:statdate)
    act_num.each do |key,vals|
      act_num[key] = vals.group_by(&by)
    end

    #注册和激活渠道
    result = []
    day_length = days_ary.length
    (reg_map | act_map).each do |code|
      tmp_h = Hash.new(0)
      tmp_h[by] = code
      if by == :channel
        next if by == :channel && !channel_map.include?(code) && coop_type != 0 #非所有时展示所有
        chl_model = channel_map[code]&.first
        tmp_h[:chl_name] = chl_model&.channel || '非确认渠道'
        tmp_h[:coop_type] = ChannelCodeInfo::CoopType[coop_type] || ChannelCodeInfo::CoopType[chl_model.balance_way.to_i]
      end

      total = 0
      p_zero_len = 0
      a_zero_len = 0
      days_ary.each do |dt|
        date = dt.to_s(:db)
        pnum = pay_num.dig(date,code)&.first&.count.to_i
        p_zero_len+=1 if pnum == 0
        anum = act_num.dig(date,code)&.first&.count.to_i
        a_zero_len+=1 if anum == 0
        tmp_h[date] = cate == :avg ? (anum == 0 ? 0 : (pnum * 100.0 / anum) ).round(2) : pnum
        total += tmp_h[date]
      end


      if by == :channel
        tmp_h[:avg] = (total/day_length).round(2)
      else
        if cate == :avg
          a_zero_len = day_length - a_zero_len
          tmp_h[:avg] = (a_zero_len == 0 ? 0 : total / a_zero_len).round(2)
        else
          p_zero_len = day_length - p_zero_len
          tmp_h[:avg] = (p_zero_len == 0 ? 0 : total / p_zero_len).round(2)
        end
      end
      result.push(tmp_h)
    end

    Rails.logger.debug result
    render json: result
  end

  #首充账户分析-注册天数
  #by: reg 注册天数， money 充值金额， level 充值级别
  def first_charge_by
    by = case params[:by]
         when 'reg'
           cons = {'0天':0,'1天':1, '2-6天': 2..6, '7-13天':7..13, '2周以上':14..}
           :chargedayinfo
         when 'money'
           cons = {'￥1':1,'￥2-10':2..10, '￥11-30': 11..30, '￥31-50':31..50, '￥51-100':51..100, '￥100以上':101..}
           :chargemoneyinfo
         when 'level'
           cons = {'0-5级':0..5,'6-10级':6..10, '11-15级': 11..15, '16-20级':16..20, '21-26级':21..25,'26-30级':26..30, '30级以上':31..}
           :chargelevelinfo
         end

    days_ary = (@sdate..@edate).to_a

    data1 = StatActiveFeeDay.select("statdate, #{by}").by_date(@sdate,@edate).where(gamecode: @gid).group_by(&:statdate)
    data1.each do |dt, vals|
      Rails.logger.error '长度大于1，需重新处理！ ' if vals.length > 1
      data1[dt] = vals.first.send(by).scan(/(\d+)%(\d+)/)
    end

    result = []
    (@sdate..@edate).each do |dt|
      date = dt.to_s(:db)
      tmp = Hash.new(0)
      tmp[date] = date
      vals = data1[date] || []
      total = 0

      cons.each do |key, val|
        num = 0
        vals.each do |it|
          _num = it[1].to_i
          if val === it[0].to_i
            num += _num
          end
        end
        tmp[key] = num
        total += num
      end

      tmp[:total] = total
      result.push(tmp)
    end


    Rails.logger.debug result
    render json: result
  end

end
