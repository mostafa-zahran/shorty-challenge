require 'redis'
require 'json'
require_relative './shorty_repository.rb'

# RedisDataStore initialization for all Repositories that will depend on
# redis data store
module RedisDataStore
  LOCAL_REDIS = { host: '127.0.0.1', port: 6379 }.freeze
  REMOTE_REDIS = { url: ENV['REDIS_URL'] }.freeze
  $redis ||= Redis.new(ENV['REDIS_URL'] ? REMOTE_REDIS : LOCAL_REDIS)
end
