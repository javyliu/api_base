class StatUseractiveDay < PipstatRecord
  self.table_name = 'stat_useractive_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda{|gid| where(gameswitch: gid)}
end
