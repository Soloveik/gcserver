require 'socket'
task :socketserver => :environment do 
  $server = TCPServer.new('simply.su',4001)
  # puts $server.inspect
  
  while $redis.get("socket") == "on"
    # puts $server.inspect
    Thread.start($server.accept) do |client|
      client.puts "1234567" 
      # puts $server.inspect
      client.close
    end
  end
  puts "done"
end

