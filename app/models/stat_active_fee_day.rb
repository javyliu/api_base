class StatActiveFeeDay < PipstatRecord
  self.table_name='stat_active_fee_day'

  scope :by_statdate, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }

  #付费账户数、活跃账户数
  #select statdate, gamecode, feenum,  activenum  from stat_active_fee_day where gamecode in ( 124,113,108,130,129,128,127,123,97,126,73,62,80,78,57,34,25,10,8,1) and statdate >= '2020-01-01' and statdate <= '2020-01-02'
  #return: [gamecode, feenum, activenum, feenum/activenum]
  def self.get_fee_active(sdate, edate, gids)
    days_count = (Date.parse(edate) - Date.parse(sdate)).to_i+1
    arr_objs = select('gamecode, sum(feenum) feenum,  sum(activenum) activenum').by_gameid(gids).by_statdate(sdate, edate).group(:gamecode).to_a
    return_gids = arr_objs.map(&:gamecode)
    old_gids = Array.wrap(gids) - return_gids
    p "------old_gids: #{old_gids}"
    old_arr = old_gids.presence && StatAccountDay.select("gameswitch as gamecode, sum(activeuser) activenum").by_gameid(old_gids).by_statdate(sdate,edate).group(:gamecode).to_a || []

    result = (arr_objs + old_arr).group_by{|item| item.gamecode}
    result.each do |gid, vals|
      item = vals.first
      result[gid] = {feenum: item.feenum/days_count,activenum: item.activenum/days_count, avg: item.activenum == 0 ? 0 : (item.feenum*100.0 / item.activenum).truncate(2) }
    end
  end


end
