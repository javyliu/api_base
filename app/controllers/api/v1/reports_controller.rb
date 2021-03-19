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
    game_hash = Game.partition_map

    hour_data.each do |gpar, val|
      r1 = {}.merge(StatIncome3Day::TimeTpl,val)
      r1['gamename'] = game_hash[gpar].gameName
      r1['total'] = val.values.reduce{|sum, it| sum+=it}
      hour_data[gpar] = r1
    end
    render json: hour_data.values
  end


  #指定时间区间充值额度大于某值的用户列表
  #/api/v1/accounts_gt_money?sdate=2021-01-01&edate=2021-01-07&money=1500
  def accounts_gt_money
    sdate = params[:sdate]
    edate_1 = params[:edate]
    money = params[:money]

    raise "请输入正确的参数" unless sdate.present? && edate_1.present? && money.present?

    file_name = "#{sdate}~#{edate_1}充值返利名单"


    edate = Date.parse(edate_1).next_day.to_s(:db)
    fee_accounts = TblFee.select('accountid,name, sum(money)/100 money, `partition`').where('money > 0').by_finished_time(sdate,edate).group(:accountid).having('money >= ?', money).joins('inner join tbl_account on tbl_account.id = accountid').to_a

    account_ids = fee_accounts.map(&:accountid)
    buy_ids = TblBuy.select('max(id) id').where(accountid: account_ids).group(:accountid).map(&:id)

    buy_accounts = TblBuy.select('accountid, partition, playerid, playername').where(id: buy_ids).group_by(&:accountid)
    buy_accounts = buy_accounts.each do |key,vals|
      buy_accounts[key] = vals.group_by(&:partition)
    end

    gmap = Game.partition_map



    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet(file_name)
    #invalid
    #worksheet.auto_width = true

    worksheet.write_row(0,'游戏名称,账号ID,账户名,角色ID,角色名,角色所在分区,活动期间充值金额'.split(','), workbook.bold_format)

    #联运用户有:分隔，官网用户没有
    fee_accounts.each do |item|
      if /:/ =~ item.name
        next
      end
      buy_item = buy_accounts.dig(item.accountid,item.partition)&.first
      partition = buy_item&.partition

      par_key = partition[/[a-z_]+(?=_\d)/,0]

      game_name = gmap[par_key]&.gameName
      worksheet << [game_name, item.accountid, item.name, buy_item&.playerid, buy_item&.playername, partition,item.money]
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
