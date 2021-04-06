class TblDept < MetedataRecord
  self.table_name = 'tbl_dept'
  has_many :users, foreign_key: :deptName, class_name: 'TUser'
end
