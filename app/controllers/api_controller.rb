require 'open-uri'
class ApiController < ApplicationController
  require 'fast_base'
  before_action :wry_params, only: [:wry, :wry_group]
  before_action :loc_params, only: [:im_here, :im_here_group]
  before_action :get_and_im_params, only: [:get_my_data, :im]
  before_action :new_group_params, only: [:new_group]
  before_action :add_del_params, only: [:add_user_to_group, :del_user_from_group]
  before_action :leave_params, only: [:leave_the_group]

  
  def wry
    data = wry_params
    if !data[:owner].blank? &&  !data[:target].blank?
      data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
      FastBase.set("req|wry", data.to_json)
      request = {status: "OK", method: "wry"}
    else
      request = {status: "ERROR", method: "wry"}
    end
    render json: request.to_json
  end

  def wry_group
    data = wry_params
    if !data[:owner].blank? &&  !data[:target].blank?
      data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
      FastBase.set("req|wryg", data.to_json)
      request = {status: "OK", method: "wryg"}
    else
      request = {status: "ERROR", method: "wry_group"}
    end
    render json: request.to_json
  end

  def im_here
    data = loc_params
    if !data[:owner].blank? && !data[:target].blank? && !data[:location].blank?
      data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
      FastBase.set(data[:target], data.to_json)
      request = {status: "OK", method: "imh"}
    else
      request = {status: "ERROR", method: "imh"}
    end
    render json: request.to_json
  end

  def im_here_group
    data = loc_params
    if !data[:owner].blank? && !data[:target].blank? && !data[:location].blank?
      data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
      FastBase.set("req|imhg", data.to_json)
      request = {status: "OK", method: "imhg"}
    else
      request = {status: "ERROR", method: "imhg"}
    end
      render json: request.to_json
  end

  def get_my_data
    data = get_and_im_params
    if !data[:owner].blank?
      data = FastBase.get_and_del_by_key(data[:owner])
      request = {status: "OK", method: "gmd", data: data.to_json}
    else
      request = {status: "ERROR", method: "gmd"}
    end
      render json: request.to_json
  end

  def im
    data = get_and_im_params
    if User.where(phone: data[:owner]).blank? && data[:owner].count == 10
      User.create(phone: data[:owner])
      request = {status: "OK", method: "im"}
    else
      request = {status: "ERROR", method: "im"}
    end
    render json: request.to_json
  end
  
  def new_group
    data = new_group_params
    user = User.where(phone: data[:owner]).first
    if User.where(phone: data[:phone]).first
      user.groups.create(name: data[:name], admin: user.id)
      Group.last.users << user
      data  = user.groups.last
      request = {name: data[:name], id_group: data[:id], status: "OK", method: "new_group"}
    else
      request = {status: "ERROR", method: "new_group"}
    end
    render json: request.to_json
  end
  
  def add_user_to_group
    data = add_del_params
    begin
      group = Group.find(data[:id_group])
      if  group.users.map{|e| e[:phone]}.include?(data[:owner]) && !group.users.map{|e| e[:phone]}.include?(data[:need_add_user])
        group.users << User.where(phone: data[:need_add_or_del_user])
        FastBase.set("req|autg", data.to_json)
        request = {status: "OK", method: "add_user_to_group"}
      else
        request = {status: "ERROR", method: "add_user_to_group"}
      end
      render json: request.to_json
    rescue ActiveRecord::RecordNotFound  
      request = {status: "ERROR", method: "add_user_to_group"}
      render json: request.to_json
    end
  end

  def del_user_from_group
    data = add_del_params
    begin
      group = Group.find(data[:id_group])
      if User.find(group[:admin]).phone == data[:owner]
        group.users.delete(User.where(phone: data[:need_add_or_del_user]))
        FastBase.set("req|dufg", data.to_json)
        request = {status: "OK", method: "del_user_from_group"}
      else
        request = {status: "ERROR", method: "del_user_from_group"}
      end
      render json: request.to_json
    rescue ActiveRecord::RecordNotFound
      request = {status: "ERROR", method: "del_user_from_group"}
      render json: request.to_json
    end
  end

  def leave_the_group
    data = leave_params
    begin  
      group = Group.find(data[:id_group])
      if  group.users.map{|e| e[:phone]}.include?(data[:owner])
        group.users.destroy(User.where(phone: data[:owner]).first)
        FastBase.set("req|dufg", data.to_json)
        request = {status: "OK", method: "leave_the_group"}
      else
        request = {status: "ERROR", method: "leave_the_group"}
      end
      render json: request.to_json
    rescue ActiveRecord::RecordNotFound
      request = {status: "ER", method: "leave_the_group"}
      render json: request.to_json
    end
  end

  private
  
  def wry_params
    params.permit(:owner, :target)
  end

  def loc_params
    params.permit(:owner, :target, :lacation)
  end

  def get_and_im_params
    params.permit(:owner)
  end

  def new_group_params
    params.permit(:owner, :name)
  end

  def add_del_params
    params.permit(:owner, :id_group, :need_add_or_del_user)
  end

  def leave_params
    params.permit(:owner, :id_group)
  end
end

