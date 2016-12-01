require 'emulator'
task :cliemulator => :environment do 
  
  emul_obj = Emulator.new(2, "simply.su", 80, 4001, 1)
  emul_obj.cycle(10)
  
end

