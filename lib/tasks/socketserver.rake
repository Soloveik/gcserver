require 'socket'
task :socketserver => :environment do 
  $server = TCPServer.new('simply.su',4001)
  # puts $server.inspect
  
  while 1
    # puts $server.inspect
    Thread.start($server.accept) do |client|
      client.puts "1234567" 
      # puts $server.inspect
      client.close
    end
  end
  puts "done"
end

