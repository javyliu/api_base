class StatActivationChannelDay < PipstatRecord
  self.table_name='stat_activation_channel_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_channel, lambda { |chl| where(chlcode: chl) }
  scope :by_gameid, lambda { |gids| where(gamecode: gids) }

  def self.activated_num(sdate,edate,gid)
    result = select('statdate, total as activated_num').where(gamecode: gid).by_date(sdate,edate).group_by(&:statdate)
    result.each do |key,vals|
      result[key] = vals.reduce{|sitem,item| sitem.activated_num+=item.activated_num;sitem}.attributes.slice('statdate','activated_num')
    end

  end
end
