class Api::V1::GamesController < ApplicationController
  before_action :game_params, except: [:index]
  include NewUserAnalyse
  include PayAnalyse
  include ActivityAnalyse
  include LostAnalyse
  include BuyAnalyse
  include SyntheticAnalyse

  #返回所有游戏列表
  def index
    data = Hash[Game.pluck(:gameid, :gamename)]
    Rails.logger.info data.inspect
    render json: data
  end

  #某个游戏总体数据一览
  def show
    data1 = StatIncome3Day.get_income(@sdate,@edate,@gid, with_date: true)
    Rails.logger.info "-----------"
    Rails.logger.info data1
    data2 = StatUserDay.get_max_and_avg_online(@sdate,@edate,@gid, with_date: true)
    Rails.logger.info data2
    data3 = PipAccountDay.get_new_players(@sdate,@edate,@gid, with_date: true)
    Rails.logger.info data3
    data4 = StatActiveFeeDay.get_fee_active(@sdate,@edate,@gid, with_date: true)
    Rails.logger.info data4

    data = data1.deep_merge(data2).deep_merge(data3).deep_merge(data4)
    render json: data.values
  end

  #单产品实时数据
  #params id: 游戏id, cate: [reg_account:新增设备数走势,reg_channel: 新增设备渠道走势, income: 收入走势 ,income_channel: 收入渠道 active: 活跃用户, online:在线人数]
  def time_data
    cate = params[:cate]
    result = case cate
             when "reg_account"
               by = :time
               TblRealtimereg.data(@sdate,@edate, @gid, group_att: :time)
             when "reg_channel"
               by = :channel
               TblRealtimereg.data(@sdate,@edate, @gid, group_att: :channel)
             when "income"
               by = :time
               TblRealtimefee.data(@sdate,@edate, @gid, group_att: :time)
             when "income_channel"
               by = :channel
               TblRealtimefee.data(@sdate,@edate, @gid, group_att: :channel)
             when "active"
               TblRealtimeactive.data(@sdate,@edate, @gid)
             when "online"
               TblRealtimeonline.data(@sdate,@edate, @gid)
             end

    if by == :channel
      channel_map = ChannelCodeInfo.channel_map(@gid).group_by(&:code)
      result.each do |key,val|
        val["name"] = channel_map[key].first.try(:channel)
      end
    end
    render json: result.sort.map(&:last)
  end

  ########--自定义查询--########
  #m1,m2：金额区间
  #cate: detail | agg
  #充值查询
  def custom_query
    result = []
    data1 = if params[:cate] == 'detail'
              StatIncomeSumDay.select("accountid, name,registerchannel,paychannel, money1/100 as money,regioncode,createtime,finishtime, amount/#{PipItemconsumeDay::ConsumeDivisor[@gid]} amount").by_date(@sdate,@edate).by_gameid(@gid)
            else
              StatIncomeSumDay.select("accountid, name, sum(money1)/100 as money, regioncode, sum(amount)/#{PipItemconsumeDay::ConsumeDivisor[@gid]} amount").where("finishtime >= ? and finishtime <= ?", @sdate,@edate.next_day).by_gameid(@gid).group(:accountid)
            end
    Rails.logger.info data1.to_sql
    data1 = data1.having("money >= ?",params[:m1]) if params[:m1].present?
    data1 = data1.having("money <= ?",params[:m2]) if params[:m2].present?
    data1 = data1.to_a

    account_ids = data1.map(&:accountid)

    buy_accounts = []

    len = account_ids.length
    TblBuy.query_data(@sdate,@edate,@gid) do |_mp|
      break if buy_accounts.length >= len  #如已找到对应的角色则不再查找
      buy_accounts.push(*TblBuy.data_from_tb(account_ids, db: _mp[:db], tb: _mp[:tb]))
    end

    buy_accounts = buy_accounts.group_by(&:accountid)

    data1.each do |item|
      tmp = {}
      buy_item = buy_accounts.dig(item.accountid)&.first
      partition = item.regioncode || buy_item&.partition

      tmp[:accountid] = item.accountid
      tmp[:name] = item.name
      tmp[:par] = partition
      if params[:cate] == 'detail'
        tmp[:chl] = item.registerchannel
        tmp[:ctime] = item.createtime.strftime('%F %T')
        tmp[:ftime] = item.finishtime.strftime('%F %T')
        tmp[:pay_chl] = item.paychannel
      end
      tmp[:playerid] = buy_item&.playerid
      tmp[:player_name] = buy_item&.player_name
      tmp[:money] = item.money.round(2)
      tmp[:yb] = item.amount.to_i
      result.push(tmp)
    end

    render json: result
  end

  #自定义查询-消费查询
  #item_name: 道具名称
  #yb1-yb2: 消费元宝区间
  #par: 分区
  #cate: detail | agg
  #/api/v1/games/10/consume_query?sdate=2021-01-01&edate=2021-01-07&m1=5000&cate=agg&per_page=10&lastid=0
  def consume_query
    per_page = (params[:per_page] || 10).to_i
    lastid = params[:lastid] || 0

    #Consume = Struct.new(:partition, :playerid, :player_name, :accountid,:yb,:itemname, :itemcount, :buytime,:name)
    sql_ary = if params[:cate] == 'agg'
                [["select id,`partition`,playerid,playername,accountid,sum(price/#{PipItemconsumeDay::ConsumeDivisor[@gid]}) price from %s where buytime between ? and ?"],[@sdate,@edate.next_day]]
              else
                [["select id,`partition`,playerid,playername,accountid,(price/#{PipItemconsumeDay::ConsumeDivisor[@gid]}) price,itemname,itemcount,buytime from %s where buytime between ? and ?"],[@sdate,@edate.next_day]]
              end
    if params[:item_name].present?
      sql_ary[0].push("and itemname like ?")
      sql_ary[1].push("%%#{params[:item_name]}%%")
    end

    #分页
    sql_ary[0].push("and id > ?")
    sql_ary[1].push(lastid)

    #agg 时需group
    sql_ary[0].push("group by playerid, `partition`") if params[:cate] == 'agg'

    if params[:m1].present?
      sql_ary[0].push(" having price >= ? ")
      sql_ary[1].push(params[:m1])
    end

    if params[:m2].present?
      sql_ary[0].push(" having price <= ? ")
      sql_ary[1].push(params[:m2])
    end

    sql_ary[0].push("limit ?")
    sql_ary[1].push(per_page)

    sql_ary[0] = sql_ary[0].join(' ')
    sql = TblBuy.sanitize_sql(sql_ary.flatten)

    data1 = TblBuy.query_data(@sdate,@edate, @gid) do |_mp|
      sql = sql % _mp[:tb]
      Rails.logger.info sql
      _mp[:db].connection.execute(sql).to_a
    end

    account_ids = data1.map(&:fifth).uniq

    account_result =  if account_ids.present?
                        TblBuy.query_data(@sdate,@edate, @gid) do |_mp|
                          _mp[:db].connection.execute("select id, name from tbl_account where id in (#{account_ids.join(',')})").to_a
                        end
                      end

    account_result = account_result&.group_by(&:first)

    data = data1.map do |it|
      tmp = TblBuy::Consume.new(*it[1..])
      tmp.buytime = tmp.buytime.strftime('%F %T') if tmp.buytime
      tmp.name = account_result[tmp.accountid]&.first&.last
      tmp
    end

    result = {data: data, lastid: data1.last&.first}

    render json: result

  end

  #获取游戏分区信息
  def area_list
    area_list = GamePartition.select('regionId,regionName, combineRegion').by_gameid(@gid).where(regionState: 1).order('regionId').to_a.each do |it|
      it.combineRegion = "#{GamePartition::PartitionPrefix[@gid.to_i]}#{it.combineRegion.scan(/\w+_#{it.regionId.to_s.rjust(2,'0')}/).first}"
    end
    result = area_list.map{|it| it.slice(:regionId, :combineRegion)}
    render json: result
  end












  private
  def game_params
    @sdate = Date.parse(params[:sdate])
    if params[:edate]

      @edate = Date.parse(params[:edate])
      if @edate >= Date.today
        @edate = Date.today - 1.day
      end
    end
    @gid = params[:id]

  end

end
