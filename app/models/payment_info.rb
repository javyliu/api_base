class PaymentInfo < PipstatRecord
  #gamecode	游戏ID
  #paycode	计费通道代码（原始）
  #payrate	通道费率
  #taxrate	税率
  #precentrate	分成比例（合作方）
  #payname	计费通道名称
  #typecode	合作模式编号（1/2）
  #typename	合作模式名称（官网/联运）
  #channel_income	计费通道代码（统计格式）
  #company	公司名称
  #cooperate	合作方简称（现与通道名称相同）
  #username	联运渠道合同管理：商务负责人
  #status	联运渠道合同管理：签署状态（0待确认/1未合作/2未签署/3签署中/4合作中）
  #startdate	联运渠道合同管理：协议开始日期
  #enddate	联运渠道合同管理：协议结束日期
  #settledate	联运渠道合同管理：结算截止日期
  #info1	联运渠道合同管理：备注
  #info	计费通道管理：备注

  self.table_name = 'payment_info'
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }
  TypeCode = [[1,'官网'],[2,'联运']]
end
