class StatIncomeSumDay < PipstatRecord
  self.table_name = 'stat_income_sum_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda{|gid| where(gamecode: gid)}
end
