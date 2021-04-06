class Api::V1::SessionsController < ApplicationController

  #创建session
  def create
    raise 'auth failed' if user_params[:name].blank? || user_params[:password].blank?

    user = TUser.select('password').find_by(userName: user_params[:name])

    raise 'auth failed, pwd not right' unless user&.valid_password?(user_params[:password])

    render json: {token: encode({user_id: user.id})}

  end


  private
  #only allow a trusted parameter 'white list' through.
  def user_params
    params.require(:user).permit(:name, :password)
  end

  def set_user
    @user = TUser.find_by(userName: user_params[:name])
  end

  def check_owner
    head :forbidden if @user.id != current_user&.id
  end
end
