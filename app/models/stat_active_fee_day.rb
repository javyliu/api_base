class StatActiveFeeDay < PipstatRecord
  self.table_name='stat_active_fee_day'

  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }

  #付费账户数、活跃账户数
  #select statdate, gamecode, feenum,  activenum  from stat_active_fee_day where gamecode in ( 124,113) and statdate >= '2020-01-01' and statdate <= '2020-01-02'
  #return: [gamecode, feenum, activenum, feenum/activenum]
  def self.get_fee_active(sdate, edate, gids, with_date: false)
    if by_date
      groups = :statdate
      selects = 'statdate, sum(feenum) feenum,  sum(activenum) activenum'
    else
      groups = :gamecode
      selects = 'gamecode, sum(feenum) feenum,  sum(activenum) activenum'
    end
    result = select(selects).by_gameid(gids).by_date(sdate, edate).group(groups).to_a

    unless by_date
      return_gids = result.map(&:gamecode)
      old_gids = Array.wrap(gids) - return_gids
      p "------old_gids: #{old_gids}"
      old_arr = old_gids.presence && StatAccountDay.select("gameswitch as gamecode, sum(activeuser) activenum").by_gameid(old_gids).by_date(sdate,edate).group(:gamecode).to_a || []
      result += old_arr
    end

    result = result.group_by{|item| item.send(groups)}

    result.each do |key, vals|
      item = vals.first
      result[key] = item.attributes.except('id')
      result[key]['avg'] = item.activenum == 0 ? 0 : (item.feenum*100.0 / item.activenum).truncate(2)

      unless by_date
        days_count = (Date.parse(edate) - Date.parse(sdate)).to_i+1
        result[key]['feenum'] /= days_count
        result[key]['activenum'] /= days_count
      end
    end

    result
  end


end
