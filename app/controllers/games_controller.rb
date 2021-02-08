class GamesController < ApplicationController
  def index
    data = Hash[Game.pluck(:gameid, :gamename)]
    Rails.logger.info data.inspect
    render json: data
  end
end
