require 'redis'
$redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/1', ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })