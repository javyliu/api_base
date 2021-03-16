class StatIncomefeeHour < PipstatRecord
  self.table_name = 'stat_incomefee_hour'
  scope :by_date, lambda { |sdate, edate| where(datehour: sdate..edate+1.day) }
  scope :by_gameid, lambda { |gids| where(game: gids) }

end
