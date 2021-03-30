class TblBuy < AccountRecord
  self.table_name = 'tbl_buy'

  RoleWithAccount = Struct.new(:accountid, :partition, :playerid, :player_name)
  Consume = Struct.new(:partition, :playerid, :player_name, :accountid,:yb,:itemname, :itemcount, :buytime,:name)

  #tbl_buy中有分表，3个月创建一个，每天会把3个月前的数据存到分表中,所以3个月这内的数据从tbl_buy中取，超过3个月往分表中取
  scope :by_date, lambda { |sdate,edate|
    where(finishtime: sdate..edate)
  }

  #查询,可对分表进行查询
  def self.query_data(sdate,edate,gid, &block)
    result = []
    tb_ary = tb_maps #分表
    has_archive = !AccountRecord::GidDbAry.include?(gid.to_s)

    min_date = tb_ary.first[2]
    Rails.logger.info "#{min_date.inspect}, #{has_archive.inspect}"
    #如果没有分表，龙斗士-北美等游戏都没有分表且在另一服务器上
    if !has_archive
      exec_by_gameid(gid) do |_|
        result.push(yield db: self, tb: 'tbl_buy', gid: gid,has_archive: has_archive )
      end
    elsif sdate >= min_date
      result.push(yield db: self, tb: 'tbl_buy', gid: gid,has_archive: has_archive )
    else
      idx1 = tb_ary.find_index{|it| edate >= it[1] && edate <= it[2] }.to_i
      idx2 = tb_ary.find_index{|it| sdate >= it[1] }.to_i
      (idx1..idx2).each do |idx|
        result.push(yield db: ::AccountArchive, tb: tb_ary[idx][0], gid: gid,has_archive: has_archive )
      end
    end
    result.flatten(1)
  end

  #return: [[tbl_buy_xx, sdate, edate],...]
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
  #查询账号对应的角色id及角色名
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
