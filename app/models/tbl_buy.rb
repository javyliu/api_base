class TblBuy < AccountRecord
  self.table_name = 'tbl_buy'

  RoleWithAccount = Struct.new(:accountid, :partition, :playerid, :player_name)

  #tbl_buy中有分表，3个月创建一个，每天会把3个月前的数据存到分表中,所以3个月这内的数据从tbl_buy中取，超过3个月往分表中取
  scope :by_date, lambda { |sdate,edate|
    where(finishtime: sdate..edate)
  }

  #该方法主要是为了得到账户对应的角色id及角色名
  #has_archive: 是否有分表, 默认有分表
  #[RoleWithAccount(accountid, partition, playerid, playername),...]
  def self.role_names(sdate,edate, accountids, has_archive: true)
    sdate = Date.parse(sdate) if sdate.kind_of?(String)
    edate = Date.parse(edate) if edate.kind_of?(String)
    edate = edate.next_month(3)

    min_date = first.buytime

    Rails.logger.info has_archive.inspect

    result = []
    #如无分表，直接查询
    if sdate >= min_date || !has_archive
      result.push(*data_from_tb(accountids))
    else
      if edate >= min_date
        result.push(*data_from_tb(accountids))
      end

      data1 = tb_maps #分表
      idx1 = data1.find_index{|it| edate >= it[1] && edate <= it[2] }.to_i
      idx2 = data1.find_index{|it| sdate >= it[1] }.to_i
      len = accountids.length
      (idx1..idx2).each do |idx|
        break if result.length >= len  #如已找到对应的角色则不再查找
        result.push(*data_from_tb(accountids, db: ::AccountArchive, tb: data1[idx][0]))
      end
    end

    Rails.logger.info "accountids: #{accountids.length}, result: #{result.length}"
    result
  end

  def self.tb_maps
    Rails.cache.fetch(:tb_maps, expires_in: 1.month) do
      Rails.logger.info "===缓存分表过期"
      #所有分表
      tbs = AccountArchive.connection.execute("select table_name from information_schema.tables where table_type='base table' and table_name like 'tbl_buy_%'").to_a.flatten
      #每个分表的开始和结束时间
      sql = tbs.reduce([]){|sum, it| sum.push("select '#{it}' table_name, min(buytime) sdate, max(buytime) edate from #{it}")}
      #tbl_buy备份数据表,时间倒序
      AccountArchive.connection.execute(sql.join(' union ')).to_a.sort{|obj2, obj1| obj1[1] <=> obj2[1]}
    end

  end

  private
  #return a relation
  def self.data_from_tb(accountids, db: TblBuy,tb: 'tbl_buy')
    sql = "select max(id) id from #{tb} where accountid in (#{accountids.join(',')}) group by accountid"
    Rails.logger.info sql
    buy_ids = db.connection.execute(sql).to_a.flatten #得到最近有购买的id
    Rails.logger.info buy_ids.inspect
    sql =  "select accountid, `partition`, playerid, playername from #{tb} where id in (#{buy_ids.join(',')})"
    Rails.logger.info sql
    db.connection.execute(sql).to_a.map{|it| RoleWithAccount.new(*it)}
  end



end
