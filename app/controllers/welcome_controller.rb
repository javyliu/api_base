class WelcomeController < ApplicationController
  def index
    render json: `rails routes|  awk 'BEGIN{FIELDWIDTHS ="40 7 98 300"}/api\\/v1/{print $2  $4}'`
  end
end
