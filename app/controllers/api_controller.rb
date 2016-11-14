require 'open-uri'
class ApiController < ApplicationController
  require 'fast_base'
  before_action :fb_init, only: [:wry, :wryg, :imh, :imhg, :gmd]
  def wry
    data = {owner: "1234567890", target: "0987654321", date: Time.now.strftime("%d/%m/%Y %H:%M:%S")}.to_json
    @fb.set("wry", data)
    request = {status: "OK", method: "wry"}
    render json: request.to_json
  end

  def wryg
    data = {owner: "1234567890", target: 3, date: Time.now.strftime("%d/%m/%Y %H:%M:%S")}.to_json
    @fb.set("wryg", data)
    request = {status: "OK", method: "wryg", data: @fb.get("wryg")}
    render json: request.to_json
  end

  def imh
    request = {status: "OK", method: "imh", data: params[:data]}
    render json: request.to_json
  end

  def imhg
    request = {status: "OK", method: "imhg", data: params[:data]}
    render json: request.to_json
  end

  def gmd
    request = {status: "OK", method: "gmd", data: params[:data]}
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
  
  def ng
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

