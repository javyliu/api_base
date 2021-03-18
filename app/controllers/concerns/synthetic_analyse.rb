module SyntheticAnalyse
  extend ActiveSupport::Concern

  ######-----综合数据----#####
  #渠道收支对比分析
  #coop_type:合作模式（1注册/2下载/3分成/4联运）,   没有则为 0, 即所有
  def synthetic_by
    result = []
    coop_type = params[:coop_type].to_i
    channel_map = ChannelCodeInfo.channel_map(@gid).select('userid,balance').includes(:t_user)
    channel_map = channel_map.where(balance_way: coop_type) if coop_type != 0
    channel_map = channel_map.to_a.group_by(&:code)
    #按渠道查询分成前收入,渠道收入分成后
    data1=PipIncomegroupDay.select('registerchannel, sum(money1) money1, sum(money2) money2').by_gameid(@gid).by_date(@sdate,@edate).group(:registerchannel).group_by(&:registerchannel)
    #查询充值通道的类型(官网or联运)
    data3 = PaymentInfo.select('channel_income, typecode').by_gameid(@gid).group_by(&:channel_income)
    data3.each {|key,vals| data3[key] = vals.first.typecode}
    #每个渠道分别在官网和联运通道的分成前收入, channel: 充值通道
    data2 = StatIncomeDay.select('channel,income').by_gameid(@gid).by_date(@sdate,@edate).group_by(&:channel)
    data2_chl = {}
    data2.each do |key,vals|
      val = vals.map(&:income).join.scan(/(\w+)%(\d+)/).group_by{|it|it.first}
      val.each do |_key,_vals|
        data2_chl[_key] = _vals.reduce(Hash.new(0)) do |sum,it|
          case data3[key]
          when 1
            sum[:gw]+=it[1].to_i
          when 2
            sum[:ly]+=it[1].to_i
          end
          sum
        end
      end
    end
    #时间段内不同渠道注册数
    data4 = StatAccountDay.by_gameid(@gid).by_date(@sdate,@edate).pluck(:version).join(';').scan(/-(\w+)%[0-9%]+%(\d+)/).group_by{|it|it.first}
    data4 = data4.each{|key, vals| data4[key] = vals.reduce(0){|sum,it| sum+=it.last.to_i}}
    #账户表查询渠道代码
    data5 = PipAccountDay.by_gameid(@gid).by_date(@sdate,@edate).group(:backchannel).pluck(:backchannel)
    #新增账户数
    data6 = StatActivationChannelDay.select('chlcode,sum(newaccount) newaccount').by_gameid(@gid).by_date(@sdate,@edate).group(:chlcode).group_by(&:chlcode)
    data6.each {|key, vals| data6[key] = vals.reduce(0){|sum,it| sum+=it.newaccount}.to_i}
    all_channels = data1.keys | data5
    all_channels.each do |key|
      next if  !channel_map.include?(key) && coop_type != 0
      tmp = {}
      chl_model = channel_map[key]&.first
      tmp[:channel] = key
      tmp[:chl_name] = chl_model&.channel || '非确认渠道'
      tmp[:coop_type] = ChannelCodeInfo::CoopType[coop_type] || ChannelCodeInfo::CoopType[chl_model&.balance_way.to_i]
      tmp[:principal] = chl_model&.t_user&.name
      tmp[:new_count] = data6[key].to_i
      tmp[:income_b] = (data1[key]&.first&.money1.to_i/100.0).round(2)
      tmp[:income_a] = (data1[key]&.first&.money2.to_i/100.0).round(2)
      tmp[:income_gw] = (data2_chl.dig(key,:gw).to_i/100.0).round(2)
      tmp[:income_ly] = (data2_chl.dig(key,:ly).to_i/100.0).round(2)
      tmp[:price] = (chl_model.balance.to_f / 100).round(2)
      tmp[:expend] = (data4[key].to_i * tmp[:price]).round(2)
      tmp[:remain] = (tmp[:income_a] - tmp[:expend]).round(2)
      tmp[:ir_rate] = (tmp[:expend] == 0 ? 0 : tmp[:remain] / tmp[:expend]).round(2)
      result.push(tmp)
    end
    Rails.logger.debug result.length
    Rails.logger.debug result
    render json: result
  end

end
