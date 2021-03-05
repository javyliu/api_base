class StatUseractiveDay < PipstatRecord
  self.table_name = 'stat_useractive_day'
  scope :by_statdate, lambda { |sdate, edate| where(statdate: sdate..edate) }
end
