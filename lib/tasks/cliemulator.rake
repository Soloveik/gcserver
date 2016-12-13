require 'emulator'
task :cliemulator => :environment do 
  
  emul_obj = Emulator.new(1, "localhost", 3000, 4001, 2)
  emul_obj.cycle(1)
  
end

