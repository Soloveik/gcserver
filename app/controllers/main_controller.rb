require 'gcapi'
require 'socket'
class MainController < ApplicationController

  def index
    a = Gcapi.new("shmoken").method
    render text: a
  end

  def test
    $server = TCPServer.new('simply.su',4000)
    loop do
      Thread.start($server.accept) do |client|
        # chain= client.gets
        # puts client.gets
        client.puts "123" 
        client.close
      end
    end
    render text: "hi"
  end

  def testclose

    $server.close
    render text: "closed"
  end

  def start_socket
    $flagsocket = true
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

end

