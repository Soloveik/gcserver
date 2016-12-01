require "timer"
if Rails.env == "production"
  $tasks = [
    {
      task: "rvm use ruby-2.3.0 do bundle exec rake resquest_handler RAILS_ENV=production",
      timer: 1
    }
  ]
else
  $tasks = [
    {
      task: "rake resquest_handler",
      timer: 3
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
