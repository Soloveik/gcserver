module Daemons
  class Timer

  @@PIDS_PATH = "pids.gc"
  @@LOG_PATH = "log/timer_log"

  require 'timeout'
    @@tasks = []

    def initialize
      file = File.new(@@LOG_PATH, "a")
      file.puts "from daemon: initializing"
      file.close
    end

    def main_loop task
      system task[:task]
      sleep task[:timer]
    end

    class << self
      def start
        @rd, @wr = IO.pipe
        @@tasks.each do |task|
          pid = start_task(task)
          num = -1
          write_to(@@PIDS_PATH, pid)
          @@tasks.each_with_index{|e, i| num = i if e[:task] == task[:task]}
          @@tasks[num][:pid] = pid if num != -1
        end
        @wr.close
        str = @rd.read
        if str == "[ok]"*@@tasks.count
          write_to(@@LOG_PATH, "daemon timer started ok")
        else
          write_to(@@LOG_PATH, "error while initializing daemon: ->#{str}<-")
        end
        @rd.close
      end

      def start_task task
        @pid = fork do
          @rd.close
          running = true
          Signal.trap("TERM") do
            running = false
          end
          begin
            dmn = new
            @wr.write "[ok]"
            @wr.close
            while running
              dmn.main_loop task
            end
          rescue Exception => e
            @wr.write e.to_s
            @wr.close
          ensure
            exit!(1)
          end
        end
      end

      def stop
        read_pids.map{|e| e}.each do |pid|
          begin
            Process.kill("TERM", pid)
          rescue
          end
        end
        set_tasks @@tasks
        clear_pids
      end

      def running?
        res = false
        read_pids.each do |pid|
          begin
            Timeout::timeout(0.01) do
              Process.waitpid(pid)
              if $?.exited?
                res = false
              end
            end
          rescue Timeout::Error
          rescue
          end
          res = true
        end
        res
      end

      def tasks
        @@tasks
      end

      def add_task(task, timer)
        task_exist = 0
        if @@tasks.map{|e| e[:task]}.include?(task)
          @@tasks.each_with_index{|e, i| task_exist = i if e[:task]==task}
          @@tasks.delete(@@tasks[task_exist])
        end
        @@tasks << {task: task, timer: timer, pid: nil}
      end

      def set_tasks tasks
        @@tasks = tasks.map{|e| {task: e[:task], timer: e[:timer], pid: nil}}
      end

      def del_task task
        task_exist = 0
        if @@tasks.map{|e, i| e[:task]}.include?(task)
          @@tasks.each_with_index{|e, i| task_exist = i if e[:task]==task}
          @@task.delete(@@task[task_exist])
          return true
        else
          return false
        end
      end

      def pids
        @@tasks.map{|e| e[:pid]}
      end

      def read_pids
        pids = []
        begin
          file = File.new(@@PIDS_PATH, "r")
          while (line = file.gets)
            pids << line.chop.to_i
          end
          file.close
        rescue
        end
        pids
      end

      def write_to(path, data)
        begin
          file = File.new(path, "a")
          file.puts data
          file.close
        rescue
        end
      end

      def clear_pids
        if File.exist?(@@PIDS_PATH)
          File.open(@@PIDS_PATH, 'w') {|file| file.truncate(0) }
        end
      end
    end
  end
end