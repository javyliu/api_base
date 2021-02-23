class TblRealtimefee < PipstatRecord
  self.table_name='tbl_realtimefee'
  scope :by_date,lambda { |sdate, edate| where("time >= ? and time < ?", sdate,edate) }

  def self.data(sdate, edate, gid, group_att: :time)
    att = if group_att == :time
            'right(left(time,13),2) time'
          elsif group_att == :channel
            group_att = 'channel_reg'
            group_att
          else
            group_att
          end
    selects = "#{att}, money"
    result = select(selects).where(gameid: gid).by_date(sdate,edate).group_by{|it| it.send(group_att)}
    result.each do |key,vals|
      result[key] = vals.reduce{|sitem, item| sitem.money+=item.money; sitem }.attributes.slice(group_att.to_s,'money')
      result[key]['money'] /= 100.0
    end
  end
end
