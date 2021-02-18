#某时间段内最高在线用户数按天平均（PCU）,平均在线用户数(ACU)
class StatUserDay < PipstatRecord
  self.table_name='stat_userdata_day'
  scope :by_statdate, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda { |gids| where(gameswitch: gids) }

  NeedCalHourIdx =  [0,1,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
  RegOnlineCount = /(?<=%)\d+/

  #某时间段内最高在线用户数按天平均（PCU）, 小时平均在线(ACU)
  #因为group_concat 有1024个字符限制，所以不做分组，取回后再计算
  #select statdate, gameswitch, sum(highonlinenum) as highonlinenum from stat_userdata_day where gameswitch in (gameids) and statdate >= '2021-01-01' and statdate <= '2021-01-02' group by statdate,gameswitch order by statdate asc, gameswitch asc
  #返回一个数据，每个游戏返回一个StatUserDay对像
  #用avgonlinenum 来存储计算后的pointtimeonline 时均值
  #return: [gamecode, highonlinenum, avgonlinenum]
  def self.get_max_and_avg_online(sdate,edate,gids, by_date: false)
    selects = "statdate,gameswitch, highonlinenum,pointtimeonline"
    if by_date
      groups = :statdate
    else
      groups = :gameswitch
    end

    obj_hash = select(selects).by_gameid(gids).by_statdate(sdate,edate).order(:statdate, :gameswitch).group_by{|obj| obj.send(groups)}
    obj_hash.each do |key, vals|
      obj_hash[key] = vals.reduce({highonlinenum: 0,avgonlinenum: 0}){|result, item| result[:highonlinenum]+= item.highonlinenum; result[:avgonlinenum] += item.cal_average; result}

      if !by_date
        days_count = (Date.parse(edate) - Date.parse(sdate)).to_i+1
        obj_hash[key][:highonlinenum] /= days_count
        obj_hash[key][:avgonlinenum] /= days_count
      end
    end
  end

  # "2-3时","3-4时","4-5时","5-6时","6-7时","7-8时" 不计算
  # 所以需计算的是 [0,1,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
  def cal_average
    self.pointtimeonline.scan(RegOnlineCount).values_at(*NeedCalHourIdx).map(&:to_i).reduce(&:+) / NeedCalHourIdx.length
  end


end
