class TUser < MetedataRecord
  default_scope {select('id, name')}
  self.table_name = 't_user'
end
