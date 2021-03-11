class PipIncomegroupDay < PipstatRecord
  self.table_name = 'pip_incomegroup_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }

end
