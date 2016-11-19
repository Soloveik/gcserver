module Daemons
  class Timer
  require 'timeout'
    @@tasks = []

    def initialize(loop_length_sec = 3)
      puts "from daemon: initializing"
      @delay = loop_length_sec
      @cnt = 0
    end

    def main_loop
      @cnt += 1
      puts "from daemon: running loop ##{@cnt}"
      sleep @delay
    end

    class << self
      def start
        @rd, @wr = IO.pipe
        @pid = fork do
          @rd.close
          running = true
          Signal.trap("TERM") do
            running = false
          end
          begin
            dmn = new
            @wr.write "ok"
            @wr.close
            while running
              dmn.main_loop
            end
          rescue Exception => e
            @wr.write e.to_s
            @wr.close
          ensure
            exit!(1)
          end
        end
        @wr.close
        str = @rd.read
        if str == "ok"
          puts "daemon started ok"
        else
          puts "error while initializing daemon: #{str}"
        end
        @rd.close
      end

      def stop
        unless @pid.nil?
          Process.kill("TERM", @pid)
          @pid = nil
        end
      end

      def running?
        if @pid
          begin
            Timeout::timeout(0.01) do
              Process.waitpid(@pid)
              if $?.exited?
                return false
              end
            end
          rescue Timeout::Error
          end
          return true
        else
          return false
        end
      end

      def tasks flag=0
        if(flag==1 && !@@tasks.blank?)
          @@tasks.map{|e| e[0]}
        else
          @@tasks
        end
      end

      def add_task(task, timer)
        task_exist = 0
        if @@tasks.map{|e| e[0]}.include?(task)
          @@tasks.each_with_index{|e, i| task_exist = i if e[0]==task}
          @@tasks.delete(@@tasks[task_exist])
        end
        @@tasks << [task, timer]
      end

      def del_task task
        task_exist = 0
        if @@tasks.map{|e, i| e[0]}.include?(task)
          @@tasks.each_with_index{|e, i| task_exist = i if e[0]==task}
          @@task.delete(@@task[task_exist])
          return true
        else
          return false
        end
      end
    end
  end
end