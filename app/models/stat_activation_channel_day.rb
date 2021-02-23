class StatActivationChannelDay < PipstatRecord
  self.table_name='stat_activation_channel_day'
  scope :by_statdate, lambda { |sdate, edate| where(statdate: sdate..edate) }

  def self.activated_num(sdate,edate,gid)
    result = select('statdate, total').where(gamecode: gid).by_statdate(sdate,edate).group_by(&:statdate)
    result.each do |key,vals|
      result[key] = vals.reduce{|sitem,item| sitem.total+=item.total;sitem}.attributes.slice('statdate','total')
    end

  end
end
