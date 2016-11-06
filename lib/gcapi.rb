class Gcapi
  @token = ""

  def initialize(data)
    @token = data
  end

  def method
    @token
  end

  private

  def private_method
  
  end
  
end

# set rb file to /lib
# require 'GCApi' #file_name
# data = GCApi.new(data).some_data #initialize return