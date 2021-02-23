class TblRealtimereg < PipstatRecord
  self.table_name='tbl_realtimereg'
  scope :by_date,lambda { |sdate, edate| where("time >= ? and time < ?", sdate,edate) }

  # group_att: [time: 按小时进行分组, channel：按渠道进行分组]
  def self.data(sdate,edate,gid,group_att: :time)
    att = if group_att == :time
            'right(left(time,13),2) time'
          else
            group_att
          end

    result = select("#{att},num").where(gameid: gid).by_date(sdate,edate).group_by{|it| it.send(group_att)}
    result.each do |key,vals|
      result[key] = vals.reduce{|sitem, item| sitem.num+=item.num; sitem }.attributes.slice(group_att.to_s,'num')
    end

  end
end
