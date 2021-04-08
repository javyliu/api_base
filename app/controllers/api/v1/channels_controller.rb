class Api::V1::ChannelsController < ApplicationController
  def index
    gid = params[:gid]
    result = ChannelCodeInfo.channel_map(gid)

    result = result.map{|it| {code: it.code,channel: it.channel }}

    render json: result
  end


end
