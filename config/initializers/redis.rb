if Rails.env == "production"
  $redis = Redis.new(db: 0, path: '/tmp/gcredis.sock')
else
  $redis = Redis.new(db: 0)#, path: '/tmp/redis.sock')
end