class TblRealtimeactive < PipstatRecord
  self.table_name='tbl_realtimeactive'
  scope :by_date,lambda { |sdate, edate| where("time >= ? and time < ?", sdate,edate) }

  def self.data(sdate, edate,gid)
    result = select('right(left(time,13),2) time, num').where(gameid: gid).by_date(sdate,edate).group_by(&:time)

    result.each do |key,vals|
      result[key] = vals.reduce{|sitem, item| sitem.num+=item.num; sitem }.attributes.slice('time','num')
    end

  end
end
