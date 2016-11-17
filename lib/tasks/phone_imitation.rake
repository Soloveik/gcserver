require 'socket'
require 'net/http'
task :phone_imitation => :environment do 
  hostname = 'localhost'
  port = 4001
  socket = TCPSocket.open(hostname, port)
  socket.puts "1234567890gmd?"
  result = socket.gets
  puts result
  if result.chop == "take_your_data"
    socket.close         
    url = URI.parse('http://localhost:3000/api/gmd')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
    }
    puts res.body
  else
    socket.close 
  end
  puts "done"
end

