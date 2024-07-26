require 'redis'
require 'redis-lock'

$redis = Redis.new(url: ENV["REDIS_URL"])
