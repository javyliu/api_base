class StatIncomeSumDay < PipstatRecord
  self.table_name = 'stat_income_sum_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
end
