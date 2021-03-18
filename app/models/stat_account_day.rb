#新增账户数(老版本),部分老游戏取账户，针对海外接口里的游戏取adduser 如：64（TOA)该游戏已停
#gameswitch	游戏ID
#statdate	日期
#regnum	（已停用）
#adduser	新建账户数
#leaveuser	离开用户数
#model	活跃账户机型分布：机型%活跃账户数；
#version	活跃账户版本分布：版本-渠道%？%？%？%？%？%？%？；
#loguser	登陆账户明细：账户ID%当日在线时长（s）；
#reguser	新增注册数
#activeuser	活跃账户数
#regandpayuser	新注册用户中付费用户（未使用）

class StatAccountDay < PipstatRecord
  self.table_name='stat_accountdata_day'

  scope :by_gameid, lambda{|gid| where(gameswitch: gid)}
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }

  #取得游戏每天去重后活跃数,表作了汇总，每个游戏每天一条数据
  #select statdate, gameswitch, activeuser from stat_accountdata_day where statdate >= '2020-01-01' and statdate <= '2020-01-02' and gameswitch in ( 124,113,108,130,129,128,127,123,97,126,73,62,80,78,57,34,25,10,8,1) order by statdate asc, gameswitch asc;
  def self.registed_users(sdate,edate,gid,group_att: :statdate)
    result = select('statdate, sum(reguser) as reguser').by_gameid(gid).by_date(sdate,edate).group(:statdate).group_by(&:statdate)
    result.each do |key,vals|
      result[key] = vals.first.attributes.slice('statdate', 'reguser')
    end
  end

  #渠道新增注册数
  #return: {'2021-02-01': [['CCCCWIP', 1,1]...]
  def self.channel_registed_users(sdate,edate,gid)
    result = select('statdate, version').by_gameid(gid).by_date(sdate,edate).group_by(&:statdate)
    result = result.each do |key,vals|
      item = vals.first
      result[key] = item.version.scan(/-(\w+)[%\d+]+%(\d+)\b/).reduce(Hash.new(0)){|rt, it| rt[it[0]]+= it[1].to_i; rt }
    end
  end


end
