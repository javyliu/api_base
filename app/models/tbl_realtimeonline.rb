#新增设备数
#select time,num from tbl_realtimereg where gameid=10 and time>='2021-02-19 00:00:00' and time<='2021-02-19 23:59:59'
#改造
#select time,sum(num) from tbl_realtimereg where gameid=10 and time>='2021-02-19 00:00:00' and time<='2021-02-19 23:59:59' GROUP BY time order by time;
#新增设备渠道走势
#select channel,sum(num) num from tbl_realtimereg where gameid=10 and time>='2021-02-19 00:00:00' and time<='2021-02-19 23:59:59'
#group by channel order by num desc
#desc tbl_realtimereg;
#收入走势
#select time,sum(money) from tbl_realtimefee where gameid=10 and time>='2021-02-19 00:00:00' and time<='2021-02-19 23:59:59'
#group by time
#活跃用户
#select time,num from tbl_realtimeactive where gameid=10 and time>='2021-02-19 00:00:00' and time<='2021-02-19 23:59:59' order by time;
#改造
#select time,sum(num) from tbl_realtimeactive where gameid=10 and time>='2021-02-19 00:00:00' and time<='2021-02-19 23:59:59'  GROUP BY time order by time;
#查询之前2个小时之内的在线人数
#select time,num from tbl_realtimeonline where gameid=10 and time>='2021-02-19 00:00:00' and time<='2021-02-19 23:59:59'

class TblRealtimeonline < PipstatRecord
  self.table_name='tbl_realtimeonline'
  scope :by_date,lambda { |sdate, edate| where("time >= ? and time < ?", sdate,edate) }
end
