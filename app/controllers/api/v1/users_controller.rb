class Api::V1::UsersController < ApplicationController
  def show
    render json: User.find(params[:id])
  end

  #post /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end

  end


  private
  #only allow a trusted parameter 'white list' through.
  def user_params
    params.require(:user).permit(:email, :password)
  end

end
