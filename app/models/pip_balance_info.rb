class PipBalanceInfo < PipstatRecord
  self.table_name = 'pip_balance_info'
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }
end
