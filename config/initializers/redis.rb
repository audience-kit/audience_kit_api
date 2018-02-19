
redis_url = Rails.application.secrets[:redis_url]

if redis_url
  uri = URI.parse redis_url
  Resque.redis = Redis.new host: uri.host, port: uri.port, user: uri.user, password: uri.password
end