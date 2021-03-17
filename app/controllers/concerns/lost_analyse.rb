module LostAnalyse
  extend ActiveSupport::Concern
  ###############流失分析###############################
  #流失综述
  #cate: 7,14,30
  #coop_type:合作模式（1注册/2下载/3分成/4联运）,   没有则为 0, 即所有
  #by channel 渠道 area 地域 sys 操作系统 level 级别 life 生命周期，fee_num 付费次数 fee_money 付费金额
  #/api/v1/games/10/lost_overview?sdate=2021-01-01&edate=2021-01-07&cate=7&by=level
  def lost_overview
    result = []
    days = (@sdate..@edate).to_a
    ori_by = params[:by]&.intern
    case ori_by
    when :channel
      #渠道号对应名称
      coop_type = params[:coop_type].to_i
      channel_map = ChannelCodeInfo.channel_map(@gid)
      channel_map = channel_map.where(balance_way: coop_type) if coop_type != 0
      channel_map = channel_map.to_a.group_by(&:code)
      data1 = StatOutflowDay.select('outflow%dchannel num1' % params[:cate])
      by = :channel
    when :area,:sys
      col_map = {area:['outflow%dareanum num1'], sys: ['outflow%dsystemnum num1'] }
      data1 = (col_map[ori_by][1] || PipOutflowDay).select(col_map[ori_by][0] % params[:cate])
      by = :like_area
    when :level
      col_map = {level:['outflow%dlevel num1',StatOutflowDay, '级']  }
      data1 = col_map[ori_by][1].select(col_map[ori_by][0] % params[:cate])
      suffx = col_map[ori_by][2]
      by = :like_level
    when :life
      col_map = {life:['outflow%dregister num1',StatOutflowDay]  }
      data1 = col_map[ori_by][1].select(col_map[ori_by][0] % params[:cate])
      con = {'当天': 0, '1周':1..7,'2周':8..14,'3周':15..21,'4周':22..28,'4周-2月':29..60,'2月-3月':61..90,'3月-6月':91..180,'6月-1年':181..365,'1年以前':366..}
      by = :like_life
    when :fee_num, :fee_money
      col_map = {fee_num:['statdate,outflow%dfeenum num1',StatOutflowDay],fee_money:['statdate,outflow%dfeetotal num1',StatOutflowDay]   }
      data1 = col_map[ori_by][1].select(col_map[ori_by][0] % params[:cate])
      con = if ori_by == :fee_num
              {'1次': 1,'2次':2,'3次':3,'4次':4,'5次':5,'6次':6,'7次':7,'8次':8,'9次':9,'10次及以上':10..}
            else
              {'1-10':1,'10-30':10,'30-50':30,'50-100':50,'100-300':100,'300-500':300,'500-1000':500,'1000-5000':1000,'5000-10000':5000,'10000以上':10000..}
            end
      by = :like_fee
    else
      data2 = StatActiveFeeDay.select('statdate,activenum').by_gameid(@gid).by_date(@sdate,@edate).group_by(&:statdate)
      data1 = StatOutflowDay.select('statdate,login%{cate}feenum num1,outflow%{cate}num num2,outflow%{cate}feenum num3' % {cate: params[:cate]})
      by = :overview
    end

    data1 = data1.by_gameid(@gid).by_date(@sdate,@edate)
    case by
    when :channel
      data1 = data1.map(&:num1).join(';').scan(/(\w+)%(\d+)/).group_by{|it| it[0]}
      data1.each do |key, vals|
        next if  !channel_map.include?(key) && coop_type != 0
        tmp = {}
        chl_model = channel_map[key]&.first
        tmp[:channel] = key
        tmp[:chl_name] = chl_model&.channel || '非确认渠道'
        tmp[:coop_type] = ChannelCodeInfo::CoopType[coop_type] || ChannelCodeInfo::CoopType[chl_model&.balance_way.to_i]
        tmp[:num] = vals.reduce(0){|sum,it| sum += it[1].to_i}
        result.push(tmp)
      end
    when :like_fee
      data1 = data1.group_by(&:statdate)
      data1 = data1.each do |key,vals|
        data1[key] = vals.map(&:num1).join(';').scan(/([^;%]+)%(\d+)/).map{|v1,v2| [v1.to_i, v2.to_i]}
      end
      all_count = data1.values.flatten(1).map{|it| it[0] == 0 ? 0 : it[1]}.sum
      con.each do |_key,_reg|
        tmp = {}
        tmp[ori_by] = _key
        total = 0
        days.each do |dt|
          date = dt.to_s(:db)
          vals = data1[date]
          tmp[date] = vals.reduce(0){|sum,it| sum += it[1] if _reg === it[0]; sum}
          total += tmp[date]
        end
        tmp[:total] = total
        tmp[:rate] = ( total*100.0/all_count ).round(2)
        result.push(tmp)
      end
    when :like_life
      data1 = data1.map(&:num1).join(';').scan(/([^;%]+)%(\d+)/).map{|v1,v2| [v1.to_i, v2.to_i]}
      con.each do |_key,_reg|
        tmp = Hash.new(0)
        tmp[ori_by] = _key
        data1.each do |it|
          tmp[:lost_num] += it[1] if _reg === it[0]
        end
        result.push(tmp)
      end
    when :like_area
      data1 = data1.map(&:num1).join(';').scan(/([^;%]+)%(\d+)/).group_by{|it| it[0]}
      data1.each do |key, vals|
        tmp = {}
        tmp[ori_by] = key
        tmp[:lost_num] = vals.reduce(0){|sum,it| sum += it[1].to_i}
        result.push(tmp)
      end
    when :like_level
      data1 = data1.map(&:num1).join(';').scan(/(\d+)%(\d+)/).group_by{|it| it[0]}
      max = data1.keys.map(&:to_i).max
      _range = (1..max)
      _range.each do |_num, _reg|
        vals = data1[_num.to_s]
        tmp = {}
        tmp[ori_by] = "#{_num}#{suffx}"
        tmp[:lost_num] = vals&.reduce(0){|sum,it| sum += it[1].to_i}.to_i
        result.push(tmp)
      end
    when :overview
      data1 = data1.group_by(&:statdate)
      days.each do |dt|
        date = dt.to_s(:db)
        tmp = {}
        tmp[:date] = date
        tmp[:act_num] = data2[date]&.first&.activenum.to_i
        tmp[:act_feenum] = data1[date]&.first&.num1.to_i
        tmp[:lost_num] = data1[date]&.first&.num2.to_i
        tmp[:lost_feenum] = data1[date]&.first&.num3&.scan(/(\d+)%(\d+)/)&.map{|v1,v2| v1=='0' ? 0 : v2.to_i}&.sum.to_i
        tmp[:act_lostrate] = (tmp[:lost_num] * 100.0 / tmp[:act_num]).round(2)
        tmp[:act_feelostrate] = (tmp[:lost_feenum] * 100.0 / tmp[:act_feenum]).round(2)
        result.push(tmp)
      end
    end

    Rails.logger.debug result
    render json: result

  end
end
