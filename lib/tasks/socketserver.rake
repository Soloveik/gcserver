require 'socket'
require "fast_base"
task :socketserver => :environment do 
  if Rails.env == "production"
    host = 'simply.su'
  else
    host = 'localhost'
  end
  $server = TCPServer.new(host, 4001)
  while 1
    Thread.start($server.accept) do |client|
      begin  
        Timeout.timeout(3) do
          result = client.gets
          result = result.chop
          indicate = result[10..14]
          phone = result[0..9]
          puts phone
          puts indicate 
          if indicate == "gmd?"
            light = FastBase.get_and_del_by_key("light#{phone}")
            if light.blank? == false
              client.puts "take_your_data"
            else  
              client.puts "data_is_missing"
            end
            client.close
          else
            client.close
          end
          puts "done"
        end
      rescue Timeout::Error
        client.close
      rescue => e
        puts e
        puts "ERROR"
      end
    end
  end
end


