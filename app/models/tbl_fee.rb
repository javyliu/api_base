class TblFee < AccountRecord

  self.table_name='tbl_fee'
  scope :by_finished_time, lambda { |stime, etime| where("finishtime >= ? and finishtime < ?", stime,etime) }
  Fee = Struct.new(:accountid,:money, :partition)



  #sanguo_test 算作sanguo
  def self.hour_data(stime,etime)
    result = select('`partition`, right(left(finishtime,13),2) hour, money').where('money>?', 0).by_finished_time(stime,etime).each do |item|
      #返回游戏名
      item.partition = Game.game_by_partition(item.partition)&.gameName
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

  #返回充值数据
  #[Fee.new(accountid,money, partition),...]
  def self.fees(sdate,edate, money: 0)
    sdate = Date.parse(sdate) if sdate.kind_of?(String)
    edate = Date.parse(edate) if edate.kind_of?(String)
    sdate = sdate #从购买表的前三个月获取角色名及角色id
    edate = edate.to_time.end_of_day
    min_date = where(charged: 1).first.finishtime
    Rails.logger.info min_date

    result = []
    if sdate >= min_date
      result.push(*data_from_tb(sdate,edate, money:money))
    else
      if edate >= min_date
        result.push(*data_from_tb(sdate,edate,money:money))
      end

      data1 = tb_maps #分表
      idx1 = data1.find_index{|it| edate >= it[1] && edate <= it[2] }.to_i
      idx2 = data1.find_index{|it| sdate >= it[1] }.to_i
      (idx1..idx2).each do |idx|
        result.push(*data_from_tb(sdate,edate, db: ::AccountArchive, tb: data1[idx][0],money: money))
      end
    end

    Rails.logger.info "result: #{result.length}"
    result
  end

  def self.tb_maps
    Rails.cache.fetch(:tb_fee_maps, expires_in: 1.month) do
      Rails.logger.info "===充值缓存分表过期"
      #所有分表
      tbs = AccountArchive.connection.execute("select table_name from information_schema.tables where table_type='base table' and table_name like 'tbl_fee_%'").to_a.flatten
      #每个分表的开始和结束时间
      sql = tbs.reduce([]) do |sum, it|
        sum.push("select '#{it}' table_name, min(finishtime) sdate, max(finishtime) edate from #{it}") if it =~ /tbl_fee_\d+/
        sum
      end
      #tbl_buy备份数据表,时间倒序
      AccountArchive.connection.execute(sql.join(' union ')).to_a.sort{|obj2, obj1| obj1[1] <=> obj2[1]}
    end

  end

  private
  #return a relation
  def self.data_from_tb(sdate,edate, db: ::AccountRecord,tb: 'tbl_fee', money: 0)
    sql =  ["select accountid, sum(money)/100 money, `partition` from #{tb} where charged = 1 and money > 0 and finishtime between '#{sdate}' and '#{edate}' group by accountid"]
    sql.push("having money >= #{money}") if money > 0
    Rails.logger.info sql.inspect
    db.connection.execute(sql.join(' ')).to_a.map{|it| Fee.new(*it)}
  end
end
