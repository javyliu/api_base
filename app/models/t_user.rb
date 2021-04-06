class TUser < MetedataRecord
  default_scope {select('id, name, deptName, email, password')}
  self.table_name = 't_user'

  has_many :purviews, foreign_key: :userid, class_name: 'TblPurview'
  belongs_to :dept, class_name: 'TblDept', foreign_key: :deptName
  has_many :roles, through: :purviews


  #通过游戏id获得用户角色
  def roles_with_gid(gid)
    roles.where("#{TblPurview.table_name}.gameid=?",gid)
  end

  #验证密码
  def valid_password?(str_pwd)
    Digest::MD5.base64digest(str_pwd) == self.password
  end

end
