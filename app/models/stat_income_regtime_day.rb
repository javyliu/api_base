class StatIncomeRegtimeDay < PipstatRecord
  self.table_name = 'stat_income_regtime_day'
  scope :by_date, lambda{|sdate,edate| where(statdate: sdate..edate)}
end
