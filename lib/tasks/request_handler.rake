require "fast_base"
task :resquest_handler => :environment do
  keys = FastBase.get_and_del_by_key("req")
  puts keys
  keys.each do |e|
    e = e.split("|")
    key = e[2]
    data = JSON.parse(Crypta.decrypt(e[3]))
    if key == "wry"
      FastBase.set(data[:target], data.to_json)
      FastBase.set_light(data[:target])
    elsif key == "wryg"
      users = Group.find(data[:target]).users 
      users.each do |p|
        if data[:owner] != p[:phone]
          data[:indicator] = "wryg"
          FastBase.set(p.phone, data.to_json)
          FastBase.set_light(p[:phone])
        else
        end
      end
    elsif key == "imhg"
      users = Group.find(data[:target]).users
      users.each do |p|
        if data[:owner] != p[:phone]
          data[:indicator] = "imhg"
          FastBase.set(p.phone, data.to_json)
          FastBase.set_light(p[:phone])
        else
        end
    elsif key == "autg"
      users = Group.find(data[:id_group]).users 
      users.each do |p|
        data[:indicator] = "autg"
        FastBase.set(p.phone, data.to_json)
        FastBase.set_light(p.phone)
      end
    elsif key == "dufg"
      users = Group.find(data[:id_group]).users 
      users.each do |p|
        data[:indicator] = "dufg"
        FastBase.set(p.phone] data.to_json)
        FastBase.set_light(p.phone)
      end
      FastBase.set(data[:need_add_or_del_user], data.to_json)
      FastBase.set_light(data[:need_add_or_del_user])
    end
  end
end