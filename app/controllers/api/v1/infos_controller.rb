class Api::V1::InfosController < ApplicationController
  def index
    data = Info.select("id, title, content").page(params[:page]).per(10)
    render json: data

  end

  def show
  end
end
