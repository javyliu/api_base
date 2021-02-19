class TblRealtimereg < PipstatRecord
  set table_name='tbl_realtimereg'
  scope :by_date,lambda { |sdate, edate| where("time >= ? and time < ?", sdate,edate) }
end
