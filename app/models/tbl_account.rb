class TblAccount < AccountRecord
  self.table_name = 'tbl_account'


  def self.name_by_accountids(ids)
    where(id: ids).pluck(:id, :name)
  end



end
