class TPurviewRelation < MetedataRecord
  self.table_name = 't_purview_relation'
  belongs_to :report, class_name: 'TblReport', foreign_key: :reportId
end
