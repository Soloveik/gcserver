class FastBase
  require "crypta"
  
  def initialize
    
  end

  def self.set(key, value)
    case value
    when String
      set_to_redis(key, value)
    when Array
      value.each{|val| set_to_redis(key, val)}
    else
    end
  end

  def self.get(key)
    $redis.keys("gcserver|#{key}|*").map do |val| 
      val = val.gsub("gcserver|#{key}|", "")
      Crypta.decrypt(val)
    end
  end
  
  # def del_by_val(key, value)
  #   puts "gcserver|#{key}|#{Crypta.crypt(value)}"
  #   $redis.del("gcserver|#{key}|#{Crypta.crypt(value)}")
  # end
  def self.get_and_del_by_key(key)
    keys = $redis.keys("gcserver|#{key}|*")
    begin
      $redis.del(keys)
    rescue
    end
    keys
  end

  def self.del_by_key(key)
    keys = $redis.keys("gcserver|#{key}|*")
    $redis.del(keys)
  end

  def self.del_all
    keys = $redis.keys("gcserver|*")
    $redis.del(keys)
  end
  
  def self.set_light(phone)
    $redis.set("gcserver|light#{phone}|", 0)
  end

  private

  def self.set_to_redis(key, value)
    $redis.set("gcserver|#{key}|#{Crypta.crypt(value)}", 0)
  end

end