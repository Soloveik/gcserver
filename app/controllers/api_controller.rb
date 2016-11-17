require 'open-uri'
class ApiController < ApplicationController
  require 'fast_base'
  before_action :fb_init, only: [:wry, :wry_group, :im_here, :im_here_group, :get_my_data]
  
  def wry
    data = {owner: "1234567890", target: "0987654321", date: Time.now.strftime("%d/%m/%Y %H:%M:%S")}.to_json
    @fb.set("wry", data)
    request = {status: "OK", method: "wry"}
    render json: request.to_json
  end

  def wry_group
    data = {owner: "1234567890", target: 3, date: Time.now.strftime("%d/%m/%Y %H:%M:%S")}.to_json
    @fb.set("wryg", data)
    request = {status: "OK", method: "wryg", data: @fb.get("wryg")}
    render json: request.to_json
  end

  def im_here
    data = {owner: "1234567890", target: "0987654321", location: "coordinats", date: Time.now.strftime("%d/%m/%Y %H:%M:%S")}
    @fb.set(data[:target], data.to_json)
    request = {status: "OK", method: "imh"}
    render json: request.to_json
  end

  def im_here_group
    data = {owner: "1234567890", target: "0987654321", group_id: 3, location: "coordination", date: Time.now.strftime("%d/%m/%Y %H:%M:%S")}
    @fb.set(data[:target], data.to_json)
    request = {status: "OK", method: "imhg"}
    render json: request.to_json
  end

  def get_my_data
    data = {owner: "1234567890", date: Time.now.strftime("%d/%m/%Y %H:%M:%S")}
    @fb.set(data[:owner], "")
    data = @fb.get_and_del_by_key(data[:owner])
    request = {status: "OK", method: "gmd", data: data.to_json}
    render json: request.to_json
  end

  def im
    if User.where(phone: params[:phone]).blank?
      User.create(phone: params[:phone])
      status = "CREATE"
    else
      status = "EXIST"
    end
    request = {status: status, method: "im", phone: params[:phone]}
    render json: request.to_json
  end
  
  def new_group
    user = User.where(phone: params[:phone]).first
    if user
      user.groups.create(name: params[:name], admin: user.id)
      request = {id_group: user.groups.last.id, status: "Group create"}
    else
      status = "ERROR"
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

end

