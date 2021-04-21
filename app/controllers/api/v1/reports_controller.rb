class Api::V1::ReportsController < ApplicationController
  before_action :sdate_params, except: [:real_time_data]
  #总体数据
  def index
    gids = @gids
    data1 = StatIncome3Day.get_income(params[:sdate], params[:edate], gids)
    Rails.logger.info "-----------"
    Rails.logger.info data1
    data2 = StatUserDay.get_max_and_avg_online(params[:sdate], params[:edate], gids)
    Rails.logger.info data2
    data3 = PipAccountDay.get_new_players(params[:sdate], params[:edate], gids)
    Rails.logger.info data3
    data4 = StatActiveFeeDay.get_fee_active(params[:sdate], params[:edate], gids)
    Rails.logger.info data4

    data = data1.deep_merge(data2).deep_merge(data3).deep_merge(data4)
    game_map = Game.partition_map(group_att: :gameId)

    data.each do |key,val|
      val['game_name'] = game_map[key].try(:gameName)
      #val.reverse_merge!(StatIncome3Day::InComeTpl)
    end

    render json: data.values
  end


  #所有产品实时收入
  def real_time_data
    hour_data = TblFee.hour_data(params[:sdate], params[:edate])

    hour_data.each do |gpar, val|
      r1 = {}.merge(StatIncome3Day::TimeTpl,val)
      r1['gamename'] = gpar
      r1['total'] = val.values.reduce{|sum, it| sum+=it}
      hour_data[gpar] = r1
    end
    render json: hour_data.values
  end

  #新增账户分布-全部产品
  #sdate,edate
  #/api/v1/reports/new_player_analyse?sdate=2021-01-01&edate=2021-01-07
  def new_player_analyse
    data1 = PipAccountDay.select('statdate,gamecode, count(1) num').by_date(@sdate,@edate).by_gameid(@gids).where(state: 1).group(:statdate,:gamecode).group_by{|it|"#{it.gamecode}#{it.statdate}"}
    data2 = StatAccountDay.select('statdate,gameswitch as gamecode, reguser as num').by_date(@sdate,@edate).by_gameid(@gids).group_by{|it|"#{it.gamecode}#{it.statdate}"}

    result = []
    gmap = Game.partition_map(group_att: :gameId)
    date_range = (@sdate..@edate).to_a
    @gids.each do |gid|
      next if gid == 0
      tmp = {}
      tmp[:gname] = gmap[gid].gameName
      sum=0
      date_range.each do |dt|
        date = dt.to_s
        tmp[date] = (data1.dig("#{gid}#{date}") || data2.dig("#{gid}#{date}"))&.first&.num.to_i
        sum+=tmp[date]
      end
      tmp[:sum] = sum
      result.push(tmp)
    end

    render json: result
  end

  ##############---充值分析---################
  #收入分布-全部产品
  #分成前/后
  #/api/v1/reports/income_analyse?sdate=2021-01-01&edate=2021-01-07
  #cate 0:分成前, 2:分成后
  def income_analyse
    cate =  (params[:cate] || "")[/\d/]
    data1 = StatIncome3Day.select("statdate, gamecode, sum(amount#{cate}) amount").by_date(@sdate,@edate).by_gameid(@gids).group(:statdate, :gamecode).group_by{|it|"#{it.gamecode}#{it.statdate}"}

    result = []
    gmap = Game.partition_map(group_att: :gameId)
    date_range = (@sdate..@edate).to_a
    @gids.each do |gid|
      next if gid == 0
      tmp = {}
      tmp[:gname] = gmap[gid].gameName
      sum=0
      date_range.each do |dt|
        date = dt.to_s
        tmp[date] = (data1.dig("#{gid}#{date}")&.first&.amount.to_f/100).round(2)
        sum+=tmp[date]
      end
      tmp[:sum] = sum.round(2)
      result.push(tmp)
    end

    render json: result
  end

  #月收入分布-全部产品
  #分成前/后
  #/api/v1/reports/income_month?sdate=2021-01&edate=2021-02
  #cate 0:分成前, 2:分成后
  def income_month
    cate =  (params[:cate] || "")[/\d/]
    data1 = StatIncome3Day.select("left(statdate,7) as statmonth, gamecode, sum(amount#{cate}) amount").by_date(@sdate,@edate).by_gameid(@gids).group(:statmonth, :gamecode).to_a

    month_ary = data1.map(&:statmonth).uniq

    data2 = data1.group_by{|it| "#{it.gamecode}#{it.statmonth}"}


    result = []
    gmap = Game.partition_map(group_att: :gameId)
    @gids.each do |gid|
      next if gid == 0
      tmp = {}
      tmp[:gname] = gmap[gid].gameName
      sum=0

      month_ary.each do |it|
        tmp[it] = (data2.dig("#{gid}#{it}")&.first&.amount.to_f/100).round(2)
        sum += tmp[it]
      end

      tmp[:sum] = sum.round(2)
      result.push(tmp)
    end

    render json: result

  end

  #收入分布-按支付合作方
  #联运收入对账单
  #取得时间段内，各个充值通道分成前/后收入
  #/api/v1/reports/income_partner?sdate=2021-01-01&edate=2021-01-07
  #cate 0:分成前,1:分成后按合作方, 2:分成后
  #typecode 2:联运，1:官服
  def income_partner
    cate =  (params[:cate] || "")[/\d/]
    data1 = StatIncome3Day.select(" s.gamecode,s.channel, sum(s.amount#{cate}) amount, p.company, p.payname").joins(" as s left join payment_info p on s.gamecode = p.gamecode and s.channel=p.channel_income").where('s.gamecode in (?) and s.statdate between ? and ?', @gids, @sdate,@edate).group('gamecode,channel')

    data1 = data1.where('p.typecode = ? ', params[:typecode][/\d/]) if params[:typecode] && params[:typecode][/\d/].present?

    chl_data = data1.group_by(&:channel)
    data1 = data1.group_by{|it| "#{it.gamecode}#{it.channel}"}
    gmap = Game.partition_map(group_att: :gameId)

    result = []
    cols_ary = {payname: '充值通道',channel: '代码',company: '合作方',sum: '总计'}
    @gids.each do |gid|
      next if gid == 0
      cols_ary[gid] = gmap[gid].gameName
    end

    chl_data.each do |chl,vals|
      tmp = {}
      chl_item = vals.first
      tmp[:payname] = chl_item&.payname
      tmp[:channel] = chl_item&.channel
      tmp[:company] = chl_item&.company || '未确认'
      sum=0

      @gids.each do |gid|
        next if gid == 0
        item = data1.dig("#{gid}#{chl}")&.first
        tmp[gid] = (item&.amount.to_f/100).round(2)
        sum += tmp[gid]
      end
      tmp[:sum] = sum.round(2)
      result.push(tmp)
    end
    render json: {result:result, cols: cols_ary}
  end

  #海外收入对账单
  #/api/v1/reports/income_haiwai?sdate=2021-01-01&edate=2021-01-07&gs=0
  #cate 0:分成前,1:分成后按合作方, 2:分成后
  #gs 0: 海外, 1: 官网， 2：联运
  def income_haiwai
    cate =  (params[:cate] || "")[/\d/]
    data1 = StatIncome3Day.select("statdate,gamecode, sum(amount#{cate}) amount ").by_gameid( @gids).by_date( @sdate,@edate).group('statdate,gamecode')

    data1 = data1.group_by{|it| "#{it.gamecode}#{it.statdate}"}
    gmap = Game.partition_map(group_att: :gameId)
    date_range = (@sdate..@edate).to_a

    result = []
    cols_ary = {date: '日期',sum: '总计'}
    @gids.each do |gid|
      next if gid == 0
      cols_ary[gid] = gmap[gid].gameName
    end

    date_range.each do |dt|
      date = dt.to_s(:db)
      tmp = {date: date}
      sum=0

      @gids.each do |gid|
        next if gid == 0
        item = data1.dig("#{gid}#{date}")&.first
        tmp[gid] = (item&.amount.to_f/100).round(2)
        sum += tmp[gid]
      end
      tmp[:sum] = sum.round(2)
      result.push(tmp)
    end
    render json: {data:result, cols: cols_ary}
  end

  #######--活跃分析--#######
  #活跃账户分布-全部产品
  def active_analyse
    @gids.delete(0)
    data1 = StatActiveFeeDay.select('statdate,gamecode, activenum as num').by_gameid(@gids).by_date(@sdate,@edate).to_a
    gids = data1.map(&:gamecode).uniq
    old_gids = @gids - gids
    data2 = []
    data1 = data1.group_by{|it| "#{it.gamecode}#{it.statdate}"}
    data2 = StatAccountDay.select('statdate,gameswitch as gamecode, activeuser as num').by_gameid(old_gids).by_date(@sdate, @edate).group_by{|it| "#{it.gamecode}#{it.statdate}"} if old_gids.present?

    gmap = Game.partition_map(group_att: :gameId)
    result = []
    cols_ary = {gname: '游戏名称',avg: '均值'}
    date_range = (@sdate..@edate).to_a
    len = date_range.length

    @gids.each do |gid|
      tmp = {}
      tmp[:gname] = gmap[gid].gameName
      sum = 0
      date_range.each do |dt|
        date = dt.to_s(:db)
        item = (data1.dig("#{gid}#{date}") || data2.dig("#{gid}#{date}"))&.first
        tmp[date] = item&.num.to_i
        sum += tmp[date]
      end
      tmp[:avg] = sum / len
      result.push(tmp)
    end

    render json: {data:result, cols: cols_ary}
  end

  #平均在线-全部产品
  def online_analyse
    @gids.delete(0)
    data1 = StatUserDay.select('statdate,gameswitch, pointtimeonline').by_date(@sdate,@edate).by_gameid(@gids).group_by{|it|"#{it.gameswitch}#{it.statdate}"}

    gmap = Game.partition_map(group_att: :gameId)
    result = []
    cols_ary = {gname: '游戏名称',avg: '均值'}
    date_range = (@sdate..@edate).to_a
    len = date_range.length

    @gids.each do |gid|
      tmp = {}
      tmp[:gname] = gmap[gid].gameName
      sum = 0
      date_range.each do |dt|
        date = dt.to_s(:db)
        items = data1.dig("#{gid}#{date}") || []
        tmp[date] = items.reduce(0){|sum,obj|sum += obj.cal_average}
        sum += tmp[date]
      end
      tmp[:avg] = sum / len
      result.push(tmp)
    end

    render json: {data:result, cols: cols_ary}

  end

  #最高平均在线-全部产品
  def max_online_analyse
    @gids.delete(0)
    data1 = StatUserDay.select('statdate,gameswitch, sum(highonlinenum) highonlinenum').by_date(@sdate,@edate).by_gameid(@gids).group(:gameswitch, :statdate).group_by{|it|"#{it.gameswitch}#{it.statdate}"}

    gmap = Game.partition_map(group_att: :gameId)
    result = []
    cols_ary = {gname: '游戏名称',avg: '均值'}
    date_range = (@sdate..@edate).to_a
    len = date_range.length

    @gids.each do |gid|
      tmp = {}
      tmp[:gname] = gmap[gid].gameName
      sum = 0
      date_range.each do |dt|
        date = dt.to_s(:db)
        item = data1.dig("#{gid}#{date}")&.first
        tmp[date] = item&.highonlinenum.to_i
        sum += tmp[date]
      end
      tmp[:avg] = sum / len
      result.push(tmp)
    end

    render json: {result:result, cols: cols_ary}

  end

  #季度综合数据-全部产品
  def quarter_data
    @gids.delete(0)
    gmap = Game.partition_map(group_att: :gameId)
    result = []
    data1 = PipQuarter.where(gamecode: @gids, quarter: @sdate..@edate).group_by(&:gamecode)
    cols_ary = {quarter:'季度', gname:'游戏名称', acctotal:'累计新增账户数', money1:'分成前收入', money2:'分成后收入', activenum:'活跃账户', feenum:'付费账户数', arpu: 'ARPU' }

    @gids.each do |gid|
      items = data1.dig(gid) || []
      items.each do |item|
        tmp = item.slice(:quarter,:acctotal, :money1, :money2, :activenum, :feenum) || Hash.new(0)
        tmp[:gname] = gmap[gid].gameName
        tmp[:arpu] = (tmp[:activenum] != 0 ? tmp[:money1].to_f / 100.0 / tmp[:activenum] : 0).round(2)
        tmp[:money1] = (tmp[:money1]/100.0).round(2)
        tmp[:money2] = (tmp[:money2]/100.0).round(2)
        result.push(tmp)
      end
    end
    render json: {result:result, cols: cols_ary}
  end


  #指定时间区间充值额度大于某值的用户列表
  #/api/v1/reports/accounts_gt_money.xlsx?sdate=2021-01-01&edate=2021-01-07&money=1500&only=gw
  def accounts_gt_money
    sdate = params[:sdate]
    edate = params[:edate]
    edate = Date.parse(edate)
    money = params[:money].to_i
    only = params[:only]

    raise "请输入正确的参数" unless sdate.present? && edate.present? && money.present?

    file_name = "#{sdate}~#{edate}充值返利名单"


    #可以通过stat_income_sum_day中来查询充值，没必要从tbl_fee中得到
    fee_accounts = StatIncomeSumDay.select("accountid, name, sum(money1)/100 money, regioncode").where("finishtime >= ? and finishtime <= ?", sdate,edate.next_day).group(:accountid).having('money>?',money)

    #需要得到角色名的话，需从不同的account 库中表tbl_buy中得到角色名
    buy_accounts = []
    fee_by_partition = fee_accounts.group_by { |it| Game.game_by_partition(it.regioncode).gameId}
    edate1 = edate.next_month(3)
    fee_by_partition.each do |key,vals|
      account_ids = vals.map(&:accountid)
      #db_gids 中存在的gid未设分表, 也就是说只有:account数据库是有分表的

      Rails.logger.info "#{key},#{account_ids}"

      len = account_ids.length
      tmp_ary = []
      TblBuy.query_data(sdate,edate1,key) do |_mp|
        break if tmp_ary.length >= len  #如已找到对应的角色则不再查找
        tmp_ary.push(*TblBuy.data_from_tb(account_ids, db: _mp[:db], tb: _mp[:tb]))
      end

      buy_accounts.push(*tmp_ary)
    end


    buy_accounts = buy_accounts.group_by(&:accountid)

    #buy_accounts = buy_accounts.each do |key,vals|
    #  buy_accounts[key] = vals.group_by(&:partition)
    #end

    respond_to do |format|
      format.json do
        result = []
        fee_accounts.each do |item|
          uname = item.name
          if only == 'gw' && /:/ =~ uname
            next
          end
          buy_item = buy_accounts.dig(item.accountid)&.first
          partition = buy_item&.partition || item.regioncode
          game_name = Game.game_by_partition(partition)&.gameName
          result << {game_name: game_name, gid: item.accountid, uname: uname, playerid: buy_item&.playerid, player_name:buy_item&.player_name, par: partition,money:item.money}
        end

        render json: result
      end
      format.xlsx do
        workbook = FastExcel.open(constant_memory: true)
        worksheet = workbook.add_worksheet(file_name)
        #invalid
        #worksheet.auto_width = true
        worksheet.write_row(0,'游戏名称,账号ID,账户名,角色ID,角色名,角色所在分区,活动期间充值金额'.split(','), workbook.bold_format)
        #联运用户有:分隔，官网用户没有
        fee_accounts.each do |item|
          uname = item.name
          if only == 'gw' && /:/ =~ uname
            next
          end
          buy_item = buy_accounts.dig(item.accountid)&.first
          partition = buy_item&.partition || item.regioncode
          game_name = Game.game_by_partition(partition)&.gameName
          worksheet << [game_name, item.accountid, uname, buy_item&.playerid, buy_item&.player_name, partition,item.money]
        end

        #write_number(row, col, number, format)
        #for i in 1..5
        #  for n in 0..3
        #    worksheet.write_number(i, n, (i+1)*(n+1), nil)
        #  end
        #end
        #chart = workbook.add_chart(Libxlsxwriter::enum_type(:chart_type)[:column])
        #chart.add_series('Bob', "Sheet1!$A$2:$A$6")
        #chart.add_series('Alice', "Sheet1!$B$2:$B$6")
        #chart.add_series('Montgomery', "Sheet1!$C$2:$C$6")
        #worksheet.insert_chart(1,7, chart)
        send_data(workbook.read_string, filename: "#{file_name}.xlsx")
      end

    end

  end


  private
  def sdate_params
    sdate = params[:sdate]
    edate = params[:edate]
    if sdate.length == 4
      #只传入年份
      sdate = "#{sdate}-01-01"
    elsif sdate.length < 10
      #传入年和月
      sdate = sdate + '-01'
    end
    if edate.length == 4
      edate = edate.to_i + 1
    elsif edate.length < 10
      edate = Date.parse(edate + '-01').end_of_month
    end

    @sdate = Date.parse(sdate)
    #只传入年时会被处理为数字
    if edate && !edate.kind_of?(Integer)
      @edate = edate.kind_of?(String) ?  Date.parse(edate) : edate
      if @edate >= Date.today
        @edate = Date.today - 1.day
      end
    end
    @gids = params[:gids] && params[:gids].split(',') || params[:gs] ? Game.by_stop_server_time(sdate).where(channelShow: params[:gs]).ids : Game.all_gids(sdate)

  end

end
