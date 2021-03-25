#所有游戏--包括海外0、自营1
#数据库表tbl_game_info里字段channelshow=0表示海外游戏，channelshow=1表示自营
#取得开始日期与该游戏是否已经停止运营时间对比
#1.如果该游戏的停止运营时间小于开始时间，则显示；反之不显示
#channelshow: 0: 表示海外游戏 1:表示自营
class Game < MetedataRecord
  self.table_name='tbl_game_info'
  self.primary_key='gameId'
  has_many :game_partitions, foreign_key: :gameId

  scope :by_stop_server_time, lambda {|sdate| where('stopservertime >= ? ', sdate).order(:showorder)}

  def self.all_gids(sdate)
    by_stop_server_time(sdate).ids
  end

  def self.partition_map(group_att: :gameCodes)
    Rails.cache.fetch("game_map_#{group_att}", expired_in: 1.month) do
      gs = Game.select("gameId,gameName,gameCodes").where(gamestate: 1).each {|item| item.gameCodes = item.gameCodes.scan(/\w+_\w+/)&.map{|it|it.gsub(/\d{2,3}$/,'')}&.uniq}
      if group_att != :gameCodes
        gs.group_by(&:gameCodes)
        gs.each do |k,v|
          gs[k] = v.first
        end
      end
      gs
    end
  end

  def self.game_by_partition(partition)
    par=partition.gsub(/@|\d{2,3}$/,"")
    partition_map.detect{|it| it.gameCodes.include?(par)}
  end


end
