class PipItemconsumeDay < PipstatRecord
  self.table_name = 'pip_itemconsume_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }

  #数据库存储消费数据与元宝的比例
  ConsumeDivisor = Hash.new(3600)
  ConsumeDivisor[123] = 100
  ConsumeDivisor[124] = 100

end
