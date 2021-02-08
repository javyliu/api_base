class Api::V1::ReportsController < ApplicationController
  def index
    AllData = Struct.new(:gid, :amount, :amount1,:highonlinenum, :avgonlinenum, :reguser, :feenum, :activenum, :avg)
    data1 = StatIncome3Day.get_income()
    data2 = StatUserDay.get_max_and_avg_online()
    data3 = PipstatRecord.get_new_players()
    data4 = StatAccountDay.get_fee_active()

  end

  private
  def report_params
    params.require(:report).permit(:sdate,:edate, gids: [])
  end
end
