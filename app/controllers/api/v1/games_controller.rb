class Api::V1::GamesController < ApplicationController
  def index
    data = Hash[Game.pluck(:gameid, :gamename)]
    render json: data
  end
end
