class TblFee < AccountRecord

  self.table_name='tbl_fee'
  scope :by_finished_time, lambda { |stime, etime| where("finishtime >= ? and finishtime < ?", stime,etime) }



  def self.hour_data(stime,etime)
    result = select('`partition`, right(left(finishtime,13),2) hour, money').where('money>?', 0).by_finished_time(stime,etime)

  end

end
