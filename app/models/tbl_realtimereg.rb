class TblRealtimereg < PipstatRecord
  self.table_name='tbl_realtimereg'
  scope :by_date,lambda { |sdate, edate| where("time >= ? and time < ?", sdate,edate) }

  def self.data(sdate,edate,gid,group_att: :time)

    att = if group_att == :time
            'right(left(time,13),2) time'
          else
            group_att

          end

    result = select("#{att},num").where(gameid: gid).by_date(sdate,edate).group_by{|it| it.send(group_att)}

    result.each do |key,vals|
      result[key] = vals.reduce{|sit, it| sit.num+=it.num;sit}.attributes.slice(group_att.to_s,'num')
    end

  end
end
