module Authenticable
  extend ActiveSupport::Concern
  def current_user
    return @current_user if @current_user

    header = request.headers['Authorization']
    return nil if header.nil?

    #反编码，如token过期，则返回空
    decoded = JsonWebToken.decode(header)
    return nil if decoded.nil?

    @current_user = TUser.unscoped.find(decoded[:user_id]) rescue ActiveRecord::RecordNotFound

  end

  protected

  def encode(payload)
    JsonWebToken.encode(payload)
  end

  def check_login
    Rails.logger.info "----current_user: #{current_user.inspect}"
    head :forbidden unless self.current_user
  end
end
