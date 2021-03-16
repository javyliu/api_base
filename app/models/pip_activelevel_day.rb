class PipActivelevelDay < PipstatRecord
  self.table_name = 'pip_activelevel_day'
  scope :by_gameid, lambda{|gid| where(gamecode: gid)}
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
end
