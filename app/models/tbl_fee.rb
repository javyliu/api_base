class TblFee < AccountRecord

  self.table_name='tbl_fee'
  scope :by_finished_time, lambda { |stime, etime| where("finishtime >= ? and finishtime < ?", stime,etime) }



  #sanguo_test 算作sanguo
  def self.hour_data(stime,etime)
    result = select('`partition`, right(left(finishtime,13),2) hour, money').where('money>?', 0).by_finished_time(stime,etime).each do |item|
      item.partition.gsub!(/@|_\d+$|_test/,"")
    end.group_by{|it| it.partition }
    #{sanguo: {'00': [],'01': []}}
    result.each do |k,v|
      r1 = v.group_by{|it| it.hour }
      r1.each do |k1,v1|
        r1[k1] =  v1.reduce(0){|sum,it| sum+=it.money/100}
      end
      result[k] = r1
    end
  end

end
