require 'gcapi'
require 'socket'
require 'fast_base'
class MainController < ApplicationController
  before_action :fb_init, only: [:set_inf, :get_inf, :del_inf_by_val, :del_inf_by_key, :del_inf_all]
  def index
    a = Gcapi.new("shmoken").method
    render text: a
  end

  def start_socket
    Thread.new{
      system "rake socketserver"
    }
    render text: "socket is go"
  end

  def close_socket
    $flagsocket = false
    comm = %x[lsof -wni tcp:4001|awk '{print $2}']
    system("kill -9 #{comm.split("\n")[1]}")
    # Thread.new{
    #   system "rake socketclient"
    # }
    render text: "socket off"
  end

  def set_inf
    @fb.set(params[:key], params[:value])
    render text: "redis set"
  end

  def get_inf
    render text: @fb.get(params[:key]).inspect
  end

  # def del_inf_by_val
  #   @fb.del_by_val(params[:key], params[:value])
  #   render text: "OK"  
  # end

  def del_inf_by_key
    @fb.del_by_key(params[:key])
    render text: "OK"
  end

  def del_inf_all
    @fb.del_all
    render text: "OK"
  end

  private

  def fb_init
    @fb = FastBase.new
  end
end



