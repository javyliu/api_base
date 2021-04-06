class TblPurview < MetedataRecord
  self.table_name = 'tbl_purview'
  belongs_to :role, foreign_key: :purid, class_name: 'TblRole'
  belongs_to :game, foreign_key: :gameid
end
