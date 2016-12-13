class Emulator
  require "net/http"
  require "socket"
  
  @@SOCKET_SERVER_RESPONSE = "take_your_data"
  @@SOCKET_SERVER_RESPONSE_2 = "data_is_missing"
  @@SEND_TO_SERVER_SOCKET  = "1234567890gmd?"
  @@API_METHOD_PATH_WRY = "/api/wry"
  @@API_METHOD_PATH_WRYG = "/api/wryg"
  @@API_METHOD_PATH_IMH = "/api/imh"
  @@API_METHOD_PATH_IMHG = "/api/imhg"
  @@API_METHOD_PATH_GMD = "/api/gmd"
  @@API_METHOD_PATH_IM = "/api/im"
  @@API_METHOD_PATH_NG = "/api/ng"

  def initialize(user_id, host, api_port, socket_port, target_id)
    @user = User.where(id: user_id).first
    # @user = User.new(phone: "1234567890") if @user.blank?
    @target = target_id
    @target_user = User.where(id: target_id).first
    # @target_user = User.new(phone: "0987654321") if @target.blank?
    @groups = @user.groups
    @location = "300x400x500"
    # @user = User.create(phone: [0..9].map{|e| ["a".."z"][rand(25)]}.join) unless @user
    @host = host
    @api_port = api_port
    @socket_port = socket_port
    @time = Time.now.to_i
  end

  def cycle(sec)
    begin
      # target = [0..9].map{|e| ["a".."z"][rand(25)]}.join
      iteration = 0
      null_time = Time.now.to_i
      while((Time.now.to_i - null_time) < sec)
        message("**********************************************")
        message(">>  #{iteration} iteration start")
        case rand(4)
        when 0
          message("|<- " + wry(@target_user).to_s)
        when 1
          message("|<- " + wry_group(@groups.first.id).to_s)
        when 2
          message("|<- " + im_here(@target_user).to_s)
        when 3
          message("|<- " + im_here_group(@groups.first.id).to_s) 
        else
        end
        if knock("#{@host}", @socket_port, @user.phone)
          message("|<- " + get_my_data(@user.phone).to_s)
        end
        sleep 1
        message("<<<#{@user.phone}")
        message("<<  #{iteration} iteration end")
        message("**********************************************\n\n")
        message(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        iteration+=1
      end
      # puts send_request("http://#{@host}:#{@api_port}/api/gmd")
    rescue => e
      error_message e
    end
  end

  def wry target
    data = {owner: @user.phone, target: target}
    send_request(@@API_METHOD_PATH_WRY, data)
  end

  def wry_group target
    data = {owner: @user.phone, target: target}
    send_request(@@API_METHOD_PATH_WRYG, data)
  end

  def im_here target
    data = {owner: @user.phone, target: target, location: @location}
    send_request(@@API_METHOD_PATH_IMH, data)
  end

  def im_here_group target
    data = {owner: @user.phone, target: target, location: @location}
    send_request(@@API_METHOD_PATH_IMHG, data)
  end

  def get_my_data target
    data = {owner: @user.phone}
    send_request(@@API_METHOD_PATH_GMD, data)
  end

  def im target
    data = {owner: @user.phone, target: target}
    send_request(@@API_METHOD_PATH_IM, data)
  end

  def new_group target
    data = {owner: @user.phone, target: target}
    send_request(@@API_METHOD_PATH_NG, data)
  end

  def knock(host, port, phone)
    begin
      Timeout.timeout(2) do
        socket = TCPSocket.open(host, port, 2)
        socket.puts "#{phone}gmd?"
        result = socket.gets
        message "o-> " + result.to_s
        if result.chop == @@SOCKET_SERVER_RESPONSE
          socket.close 
          message("some code after knock true")
          return true
        elsif result.chop == @@SOCKET_SERVER_RESPONSE_2
          socket.close 
          message("some code after knock true without redis")
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
      error_message e
      return false
    end
  end

  def method(var)
    begin

    rescue => e
      error_message e
    end
  end

  private

  def message str
    puts "  " + str.to_s #+ " ------"
  end

  def error_message str
    puts "  ----- ERROR ---------------------------------"
    end_str = ""
    new_str = ""
    str = str.to_s.split(" ").each do |e|
      if(new_str.length < 30)
        new_str += " " + e
      else
        new_str += " " + e +"\n"
        end_str += "  | " + new_str
        new_str = ""
      end
    end
    puts end_str
    puts "  ---------------------------------------------"
  end

  def send_request(path, data)
    begin
      if @api_port == 80
        uri = "http://#{@host}#{path}?#{data.to_query}"
      else
        uri = "http://#{@host}:#{@api_port}#{path}?#{data.to_query}"
      end
      url = URI.parse(uri)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      res.body
    rescue => e
      error_message e
      return "[#{path} empty data]"
    end
  end

  def private_method(var)
    begin

    rescue => e
      error_message e
    end
  end

end