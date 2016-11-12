if Rails.env == "production"
  $redis = Redis.new(:host => "redis5.locum.ru", :db => 14)
else
  $redis = Redis.new(db: 0)#, path: '/tmp/redis.sock')
end