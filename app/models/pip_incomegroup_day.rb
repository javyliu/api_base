class PipIncomegroupDay < PipstatRecord
  #statdate	日期
  #registerchannel	充值账户的注册渠道
  #paychannel	充值通道
  #gamecode	游戏ID
  #gameregion	分区代码
  #province	充值账户所属省份
  #phonesys	充值账户的操作系统类型
  #money1	充值金额分成前（CNY分）
  #money2	充值金额分成后（CNY分）
  #regionid	分区ID
  self.table_name = 'pip_incomegroup_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }

end
