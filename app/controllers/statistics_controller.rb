class StatisticsController < ApplicationController
  
  def index
    @chart_data = []
    temp_hash = {}
    $redis.keys("gcserver|statistics|*").each do |key|
      $redis.hkeys(key).each do |hkey|
        temp_hash[hkey] ||= {label: hkey, data: []}
        counter = $redis.hget(key, hkey)
        date = (key.split("|")[2] + " " + key.split("|")[3]).to_datetime.to_i * 1000
        temp_hash[hkey][:data] << [date, counter]
      end
    end
    temp_hash.keys.each do |e|
      temp_hash[e][:data] = temp_hash[e][:data].sort_by{|p| p[0]}
      @chart_data << temp_hash[e]
    end
    @curr_hash = @chart_data
    @chart_data = @chart_data.to_json
  end

end
