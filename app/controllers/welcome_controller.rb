class WelcomeController < ApplicationController
  def index
    render json: `rails routes -g /api/v1`
  end
end
