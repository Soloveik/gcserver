class Gcapi
  require "fast_base"
  
  def initialize
  
  end
  class << self
    def wry(data)
      if !data[:owner].blank? &&  !data[:target].blank?
        data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
        FastBase.set("req|wry", data.to_json)
        request = {status: "OK", method: "wry"}
      else
        request = {status: "ERROR", method: "wry"}
      end
      return request
    end

    def wry_group(data)
      if !data[:owner].blank? &&  !data[:target].blank?
        data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
        FastBase.set("req|wryg", data.to_json)
        request = {status: "OK", method: "wryg"}
      else
        request = {status: "ERROR", method: "wry_group"}
      end
      return request
    end

    def im_here(data)
      if !data[:owner].blank? && !data[:target].blank? && !data[:location].blank?
        data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
        FastBase.set(data[:target], data.to_json)
        FastBase.set_light(data[:target])
        request = {status: "OK", method: "imh"}
      else
        request = {status: "ERROR", method: "imh"}
      end
      return request
    end
    
    def im_here_group(data)
      if !data[:owner].blank? && !data[:target].blank? && !data[:location].blank?
        data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
        FastBase.set("req|imhg", data.to_json)
        request = {status: "OK", method: "imhg"}
      else
        request = {status: "ERROR", method: "imhg"}
      end
      return request
    end
    
    def get_my_data(data)
      if !data[:owner].blank?
        data = FastBase.get_and_del_by_key(data[:owner])
        data = data.map do |p|
          p = JSON.parse(Crypta.decrypt(p.split("|")[2]))
        end
        request = {status: "OK", method: "gmd", data: data.to_json}
      else
        request = {status: "ERROR", method: "gmd"}
      end
      return request 
    end
    
    def im(data)
      if User.where(phone: data[:owner]).blank? && data[:owner].count == 10
        User.create(phone: data[:owner])
        request = {status: "OK", method: "im"}
      else
        request = {status: "ERROR", method: "im"}
      end
      return request
    end
    
    def new_group(data)
      user = User.where(phone: data[:owner]).first
      if User.where(phone: data[:phone]).first
        user.groups.create(name: data[:name], admin: user.id)
        Group.last.users << user
        data  = user.groups.last
        request = {name: data[:name], id_group: data[:id], status: "OK", method: "new_group"}
      else
        request = {status: "ERROR", method: "new_group"}
      end
      return request  
    end
    
    def add_user_to_group(data)
      begin
        group = Group.find(data[:id_group])
        if  group.users.map{|e| e[:phone]}.include?(data[:owner]) && !group.users.map{|e| e[:phone]}.include?(data[:need_add_user])
          group.users << User.where(phone: data[:need_add_or_del_user])
          FastBase.set("req|autg", data.to_json)
          request = {status: "OK", method: "add_user_to_group"}
        else
          request = {status: "ERROR", method: "add_user_to_group"}
        end
      rescue ActiveRecord::RecordNotFound  
        request = {status: "base ERROR", method: "add_user_to_group"}
      end    
      return request
    end

    def del_user_from_group(data)
      begin
        group = Group.find(data[:id_group])
        if User.find(group[:admin]).phone == data[:owner]
          group.users.delete(User.where(phone: data[:need_add_or_del_user]))
          FastBase.set("req|dufg", data.to_json)
          request = {status: "OK", method: "del_user_from_group"}
        else
          request = {status: "ERROR", method: "del_user_from_group"}
        end
      rescue ActiveRecord::RecordNotFound
        request = {status: "ERROR", method: "del_user_from_group"}
      end
      return request
    end

    def leave_the_group(data)
      begin  
        group = Group.find(data[:id_group])
        if  group.users.map{|e| e[:phone]}.include?(data[:owner])
          group.users.destroy(User.where(phone: data[:owner]).first)
          FastBase.set("req|dufg", data.to_json)
          request = {status: "OK", method: "leave_the_group"}
        else
          request = {status: "ERROR", method: "leave_the_group"}
        end
      rescue ActiveRecord::RecordNotFound
        request = {status: "ER", method: "leave_the_group"}
      end
      return request
    end

    def my_data_update(data)
      begin
        user = User.where(phone: data[:owner]).first
        data_array = []
        if !user.blank?
          user.groups.each do |e|
            users_group = e.users.map{|p| p.phone}
            data_array << {gid: e[:id], name: e[:name], admin: e[:admin], group_users: users_group}
          end
          contacts = User.where(phone: data[:my_contacts]).map{|c| c.phone}
          request = {status: "OK", method: "my_data_update", data: {groups: data_array, contacts: contacts}}
        else
          request = {status: "not found", method: "my_data_update"}
        end
      rescue ActiveRecord::RecordNotFound
        request = {status: "base ERROR", method: "my_data_update"}
      rescue
        request = {status: "ERROR", method: "my_data_update"}
      end
      return request
    end
  end
end

# set rb file to /lib
# require 'GCApi' #file_name
# data = GCApi.new(data).some_data #initialize return