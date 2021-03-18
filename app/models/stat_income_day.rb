class StatIncomeDay < PipstatRecord
  #channel	充值通道
  #gamecode	游戏ID
  #statdate	日期
  #income	充值明细：注册渠道%分成前金额%分成后金额
  self.table_name = 'stat_income_day'
  scope :by_gameid, lambda { |gids| where(gameswitch: gids) }
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }

end
