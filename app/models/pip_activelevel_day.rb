class PipActivelevelDay < PipstatRecord
  self.table_name = 'pip_activelevel_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
end
