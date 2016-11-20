require "timer"
if Rails.env == "production"
  $tasks = [
    {
      task: "rvm use ruby-2.3.0 do bundle exec rake task1",
      timer: 1
    },
    {
      task: "rvm use ruby-2.3.0 do bundle exec rake task2",
      timer: 3
    }
  ]
else
  $tasks = [
    {
      task: "echo \"123\">>test.gc",
      timer: 5
    }
  ]
end

if Daemons::Timer.tasks.blank?
  Daemons::Timer.set_tasks $tasks
end
if !Daemons::Timer.running?
  Daemons::Timer.stop if !Daemons::Timer.read_pids.blank?
  Daemons::Timer.start
end
