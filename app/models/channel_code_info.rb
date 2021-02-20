class ChannelCodeInfo < PipstatRecord
  self.table_name='channel_code_info'

  #A 安卓， I ios, P ios pack, W 暂不知
  scope :channel_map, ->(gid){joins("left join channel_info on left(channel_code_info.id_code,3) = channel_info.id_code")
    .select("channel_code_info.code, channel_code_info.channel_name,concat(channel_info.now_stat, channel_code_info.now_stat) now_stat, channel_info.operation_system").where("game=? and channel_code_info.now_stat > 0", gid)}

  def channel
    @channel = case operation_system
               when 1
                 "A|#{channel_name}"
               when 2
                 "I|#{channel_name}"
               when 3
                 "P|#{channel_name}"
               when 4
                 "W|#{channel_name}"
               end

    case now_stat
    when /3/
      "暂停前(#{@channel})"
    when /2/
      "暂停(#{@channel})"
    end
    @channel
  end
end
