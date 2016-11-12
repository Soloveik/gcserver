class Crypta
  require "base64"

  def initialize
  
  end

  def crypt(str)
    size = 145 - str.length
    trash = (0..size).map{("a".."z").to_a[rand(26)]}.join
    str += "|" + trash 
    str = Base64.encode64(str)
    str = str.chop.concat(("a".."z").to_a[rand(26)])
    [str[0..49], str[50..99], str[100..149], str[150..199]].reverse.join
  end

  def decrypt(str)
    str = [str[0..49], str[50..99], str[100..149], str[150..199]].reverse.join
    str = str.chop + "\n"
    str = Base64.decode64(str)
    str.split("|").first
  end

  private

  def private_method
  
  end
  
end
