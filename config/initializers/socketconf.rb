# begin  
# if Rails.env == "production"
# rescue
# end
# $server = TCPServer.new('localhost',4001)
# puts $server.inspect
# comm = %x[lsof -wni tcp:4001|awk '{print $2}']
# puts comm.inspect
# puts output
# end