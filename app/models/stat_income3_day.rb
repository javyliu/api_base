class StatIncome3Day < PipstatRecord
  self.table_name='stat_income3_day'

  scope :by_statdate, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }
  #收入分成前、后 amount1:分成后按合作方,amount: 分成前,amount:分成前
  #select statdate, gamecode, sum(amount) as amount, sum(amount2) as amount2 from stat_income3_day where gamecode in ( 124,113,108,130,129,128,127,123,97,126,73,62,80,78,57,34,25,10,8,1) and statdate >= '2020-01-01' and statdate <= '2020-01-02' group by statdate, gamecode
  #return: [gamecode, amount, amount1]
  def self.get_income(sdate,edate,gids)
    result = select("gamecode, sum(amount) as amount, sum(amount2) as amount2").by_gameid(gids).by_statdate(sdate,edate).group(:gamecode).group_by{|item| item.gamecode}
    result.each{|gid, vals| result[gid] = {amount: vals.first.amount/100.0, amount1: vals.first.amount2/100.0}}
  end


end
