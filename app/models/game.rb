#所有游戏--包括海外0、自营1
#数据库表tbl_game_info里字段channelshow=0表示海外游戏，channelshow=1表示自营
#取得开始日期与该游戏是否已经停止运营时间对比
#1.如果该游戏的停止运营时间小于开始时间，则显示；反之不显示
class Game < MetedataRecord
  self.table_name='tbl_game_info'
  self.primary_key='gameId'
  has_many :game_partitions, foreign_key: :gameId

  scope :by_stop_server_time, lambda {|sdate| where('stopservertime >= ? ', sdate).order(:showorder)}

  def self.all_gids(sdate)
    where("gameid > 0").by_stop_server_time(sdate).ids
  end


end