class PipActivegroupDay < PipstatRecord
  self.table_name = 'pip_activegroup_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda{|gid| where(gamecode: gid)}
end
