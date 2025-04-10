class JsonWebToken
  ACCESS_SECRET_KEY = ENV["AMS_ACCESS_SECRET_KEY"]
  ACCESS_TOKEN_EXPIRY = 24

  def self.encode(payload, exp = ACCESS_TOKEN_EXPIRY.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload,  ENV["AMS_ACCESS_SECRET_KEY"])
  end

  def self.decode(token)
    body = JWT.decode(token,  ENV["AMS_ACCESS_SECRET_KEY"])[0]
    HashWithIndifferentAccess.new body
  rescue JWT::DecodeError => e
    raise StandardError.new("Invalid token: #{e.message}")
  end
end
