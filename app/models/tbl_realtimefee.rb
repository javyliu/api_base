class TblRealtimefee < PipstatRecord
  set table_name='tbl_realtimefee'
  scope :by_date,lambda { |sdate, edate| where("time >= ? and time < ?", sdate,edate) }
end
