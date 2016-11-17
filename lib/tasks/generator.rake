task :generator => :environment do 
  1000.times do 
    phone = (0..9).map{(0..9).to_a[rand(10)]}.join.to_i
    if User.where(phone: phone).blank?
      a = User.create(phone: phone)
      puts a
    else
      puts "number is using"
    end 
  end
  ids = User.all.ids
  num = ids.count
  100.times do
    name = (0..4).map{("a".."z").to_a[rand(26)]}.join
    if Group.where(name: name).blank?
      a = Group.create(name: name , admin: ids[rand(num)])
      puts a 
    else
    end
  end
  idsg = Group.all.ids
  balance_id = ids
  idsg.each do |e|
    idusers = balance_id[0..rand(3..9)]
    users = User.find(idusers)
    Group.find(e).users<<(users)
    puts "Users add"
    balance_id = balance_id - idusers
  end
end

