class GamePartition < MetedataRecord
  self.table_name='t_game_region'
  scope :by_gameid, lambda{|gid| where(gameid: gid)}

  PartitionPrefix = {1=> '@',10=> '@', 25 => '@', 34 => '@', 123 => '@', 124 => '@'}
end
