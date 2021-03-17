class PipOutflowDay < PipstatRecord
  self.table_name='pip_outflow_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }
end
