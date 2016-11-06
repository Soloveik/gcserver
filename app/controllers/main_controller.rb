require 'gcapi'
require 'socket'
class MainController < ApplicationController

  def index
    a = Gcapi.new("shmoken").method
    render text: a
  end

  def test
    $server = TCPServer.new('simply.su',4000)
    $server.setsockopt(:SOCKET, :REUSEADDR, 1)
    $server.setsockopt(:SOCKET, :REUSEPORT, 1)
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

end

