#每天每游戏每个新增用户一条数据
class PipAccountDay < PipstatRecord
  self.table_name='pip_account_day'
  scope :by_statdate, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }
  #新增账户数(新版本)， 老游戏，如幻想，武林不会记录
  #select statdate, gamecode, count(1) as num from pip_account_day where state = 1 and gamecode in ( 124,113,108,130,129,128,127,123,97,126,73,62,80,78,57,34,25,10,8,1) and statdate >= '2020-01-01' and statdate <= '2020-01-02' group by statdate, gamecode
  #return: [gamecode, reguser]
  def self.get_new_players(sdate,edate,gids, by_date: false)
    if by_date
      groups = :statdate
      selects = " statdate, count(1) as reguser"
    else
      groups = :gamecode
      selects = " gamecode, count(1) as reguser"
    end

    result = select(selects).by_gameid(gids).by_statdate(sdate,edate).where(state: 1).group(groups).to_a

    unless by_date
      return_gids = result.map(&:gamecode)
      old_gids = Array.wrap(gids) - return_gids
      p "------old_gids: #{old_gids}"

      #老版本游戏在pip_account_day中没有数据
      players2 = old_gids.presence && StatAccountDay.select("gameswitch as gamecode, sum(reguser) as reguser").by_gameid(old_gids).by_statdate(sdate,edate).group(:gamecode).to_a || []
      result += players2
    end

    result = result.group_by{ |obj| obj.send(groups) }

    result.each do |key, vals|
      result[key] = vals.first.attributes.except('id')
    end
    result
  end


end
