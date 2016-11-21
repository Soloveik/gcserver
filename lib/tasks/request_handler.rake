require "fast_base"
task :resquest_handler => :environment do
  keys = FastBase.get_and_del_by_key("req")
  data_wry = []
  data_wryg = []
  data_autg = []
  data_dufg = []
  puts keys
  keys.map do |e|
    e = e.split("|")
    key = e[2]
    data = JSON.parse(Crypta.decrypt(e[3]))
    if key == "wry"
      
      data_wry << data
    elsif key == "wryg"
      
      data_wryg << data
    elsif key == "autg"
      
      data_autg << data
    elsif key == "dufg"
      
      data_dufg << data
    end
  end
  puts data_wryg
end