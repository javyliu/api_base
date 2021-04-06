class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  class << self

    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def decode(token)
      begin
        decoded = JWT.decode(token, SECRET_KEY).first
        HashWithIndifferentAccess.new decoded
      rescue JWT::ExpiredSignature
        nil
      rescue JWT::VerificationError
        nil
      end
    end

  end

end
