class StatIncome3Day < PipstatRecord
  self.table_name='stat_income3_day'

  scope :by_statdate, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }
  #收入分成前、后 amount1:分成后按合作方,amount: 分成前,amount:分成前
  #如果by_date为真，表示日期进行分组
  #select statdate, gamecode, sum(amount) as amount, sum(amount2) as amount2 from stat_income3_day where gamecode in ( 124,113) and statdate >= '2020-01-01' and statdate <= '2020-01-02' group by statdate, gamecode
  def self.get_income(sdate,edate,gids, by_date: false)
    #按statdate进行分组进行查询
    if by_date
      selects = "statdate,sum(amount) as amount, sum(amount2) as amount2"
      groups = :statdate
    else
      selects = "gamecode, sum(amount) as amount, sum(amount2) as amount2"
      groups = :gamecode
    end
    result = select(selects).by_gameid(gids).by_statdate(sdate,edate).group(groups)
    result = result.group_by{|item| item.send(groups)}

    #转化为元
    result.values.each do |it|
      it.each do |item|
        item.amount /= 100.0
        item.amount2 /= 100.0
      end
    end

    #仅一个游戏时返回按天分组数据,否则按游戏分组
    if by_date
      result.each {|key,vals| result[key] = vals.first.attributes.except("id")}
    else
      result.each{|gid, vals| result[gid] = vals.first.attributes.except("id")}
    end
  end
end
