class Emulator
  require "net/http"
  require "socket"
  
  def initialize(user_id, host, api_port, socket_port)
    @user = User.where(id: user_id).first
    @user = User.create(phone: [0..9].map{|e| ["a".."z"][rand(25)]}.join) unless @user
    @host = host
    @api_port = api_port
    @socket_port = socket_port
    @time = Time.now.to_i
  end

  def cycle(sec)
    begin
      iteration = 0
      null_time = Time.now.to_i
      while((Time.now.to_i - null_time) < sec)
        message(">>  #{iteration} iteration start")
        # message(Time.now.to_i - null_time)

        wry(target) if rand(5)==0

        if knock("#{@host}", @socket_port)
          mydata = get_my_data([0..9].map{|e| ["a".."z"][rand(25)]}.join)
          message("|<- " + mydata)
        end

        message("<<  #{iteration} iteration end")
        message("-----------------------")
        iteration+=1
      end
      # puts send_request("http://#{@host}:#{@api_port}/api/gmd")
    rescue => e
      message e
    end
  end

  def wry target
    data = {owner: @user.phone, target: target}
    send_request("/api/wry", data)
  end

  def wry_group target
    data = {owner: @user.phone, target: target}
    send_request("/api/wryg", data)
  end

  def im_here target
    data = {owner: @user.phone, target: target}
    send_request("/api/imh", data)
  end

  def im_here_group target
    data = {owner: @user.phone, target: target}
    send_request("/api/imhg", data)
  end

  def get_my_data target
    data = {owner: @user.phone}
    send_request("/api/gmd", data)
  end

  def im target
    data = {owner: @user.phone, target: target}
    send_request("/api/im", data)
  end

  def new_group target
    data = {owner: @user.phone, target: target}
    send_request("/api/ng", data)
  end

  def knock(host, port)
    begin
      Timeout.timeout(2) do
        socket = TCPSocket.open(host, port, 2)
        socket.puts "1234567890gmd?"
        result = socket.gets
        message "o-> " + result.to_s
        if result.chop == "take_your_data"
          socket.close 
          message("some code after knock true")
          return true
        else
          socket.close
          message("some code after knock false")
          return false
        end
      end
    rescue Timeout::Error
      message("connection timeout")
      return false
    rescue => e
      message("some code after knock error")
      message e
      return false
    end
  end

  

  def method(var)
    begin

    rescue => e
      message e
    end
  end

  private

  def message str
    puts "  " + str.to_s #+ " ------"
  end

  def send_request(path, data)
    uri = "http://#{@host}:#{@api_port}#{path}?#{data.to_query}"
    begin
      url = URI.parse(uri)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      res.body
    rescue => e
      puts e
      return nil
    end
  end

  def private_method(var)
    begin

    rescue => e
      puts e
    end
  end

end