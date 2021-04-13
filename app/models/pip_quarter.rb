class PipQuarter < PipstatRecord
  self.table_name = 'pip_quarter'
  belongs_to :game, foreign_key: :gamecode
end
