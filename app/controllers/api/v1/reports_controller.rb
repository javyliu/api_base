class Api::V1::ReportsController < ApplicationController
  #总体数据
  def index
    gids = params[:gids] && params[:gids].split(',') || Game.all_gids(params[:sdate])
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

end
