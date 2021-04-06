class TblRole < MetedataRecord
  self.table_name = 'tbl_role'
  self.primary_key = :roleid
  has_many :t_purview_relations, foreign_key: :purId

  has_many :reports, through: :t_purview_relations

end
