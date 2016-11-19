require 'open-uri'
class ApiController < ApplicationController
  require 'fast_base'
  before_action :fb_init, only: [:wry, :wry_group, :im_here, :im_here_group, :get_my_data]
  before_action :wry_params, only: [:wry, :wry_group]
  before_action :loc_params, only: [:im_here, :im_here_group]
  before_action :get_and_im_params, only: [:get_my_data, :im]
  before_action :new_group_params, only: [:new_group]
  before_action :add_del_params, only: [:add_user_to_group, :del_user_from_group]

  
  def wry
    data = wry_params
    # puts data.blank?
    if !data[:owner].blank? &&  !data[:target].blank?
      data = data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
      @fb.set("wry", data.to_json)
      request = {status: "OK", method: "wry"}
    else
      request = {status: "bad parametrs", method: "wry"}
    end
    render json: request.to_json
  end

  def wry_group
    data = wry_params
    if !data[:owner].blank? &&  !data[:target].blank?
      data = data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
      @fb.set("wryg", data.to_json)
      request = {status: "OK", method: "wryg"}
    else
      request = {status: "bad parametrs", method: "wry_group"}
    end
    render json: request.to_json
  end

  def im_here
    data = loc_params
    if !data[:owner].blank? && !data[:target].blank? && !data[:location].blank?
      data = data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
      @fb.set(data[:target], data.to_json)
      request = {status: "OK", method: "imh"}
    else
      request = {status: "bad parametrs", method: "imh"}
    end
    render json: request.to_json
  end

  def im_here_group
    data = loc_params
    if !data[:owner].blank? && !data[:target].blank? && !data[:location].blank?
      data = data[:date] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
      @fb.set(data[:target], data.to_json)
      request = {status: "OK", method: "imhg"}
    else
      request = {status: "params is bad", method: "imhg"}
    end
      render json: request.to_json
  end

  def get_my_data
    data = get_and_im_params
    if !data[:owner].blank?
      data = @fb.get_and_del_by_key(data[:owner])
      request = {status: "OK", method: "gmd", data: data.to_json}
    else
      request = {status: "params is bad", method: "gmd"}
    end
      render json: request.to_json
  end

  def im
    data = get_and_im_params
    if User.where(phone: data[:owner]).blank? && data[:owner].count == 10
      User.create(phone: data[:owner])
      request = {status: "user create", method: "im"}
    else
      request = {status: "params is bad", method: "im"}
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
      request = {name: data[:name], id_group: data[:id], status: "group create", method: "new_group"}
    else
      request = {status: "params is bad", method: "new_group"}
    end
    render json: request.to_json
  end
  
  def add_user_to_group
    data = add_del_params
    group = Group.find(data[:id_group])
    if  group.users.map{|e| e[:phone]}.include?(data[:owner]) && !group.users.map{|e| e[:phone]}.include?(data[:need_add_user])
      group.users << User.where(phone: data[:need_add_user])
      request = {status: "User is add", method: "add_user_to_group"}
    else
      request = {status: "the user is already in the group", method: "add_user_to_group"}
    end
    render json: request.to_json
  end

  def del_user_from_group
    data = add_del_params
    group = Group.find(data[:id_group])
    if User.find(group[:admin]).phone == data[:owner]
      group.users.delete(User.where(phone: data[:need_del_user]))
      status = "removed from a user group"
      request = {status: status}
    else
      status = "You are not admin"
      request = {status: status}
    end
    render json: request.to_json
  end

  def test
    # data = {im: "1234567890", who: "0987654321"}.to_json
    # response = open("http://localhost:3000#{params[:path]}?data=#{data}").read
    # @text = response
  end

  private
  
  def fb_init
    @fb = FastBase.new
  end

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
    params.permit(:owner, :id_group, :need_add_user)
  end
end

