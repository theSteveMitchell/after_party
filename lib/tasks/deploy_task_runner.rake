namespace :after_party do
  desc "runs (in order) all pending after_party deployment tasks, if they have not run yet against the current db."
  task :run => :environment do
    tasks = AfterParty::TaskRecorder.pending_files.map {|f| "after_party:#{f.task_name}"}

    tasks.each {|t| Rake::Task[t].invoke}

    if tasks.empty?
      puts "no pending tasks to run"
    end

  end

  desc "Check the status of after_party deployment tasks"
  task :status => :environment do
    tasks = Dir[AfterParty::TaskRecorder::FILE_MASK].collect do |filename|
      recorder = AfterParty::TaskRecorder.new(filename)
      task_obj = {
        version: recorder.timestamp,
        task_name: recorder.task_name.humanize,
        status: recorder.pending? ? 'down' : ' up '
      }
      recorder.post_task? ? task_obj : nil
    end.compact

    puts <<-EOF
Status   Task ID         Task Name
--------------------------------------------------
    EOF
    tasks.each do |task|
      puts " #{task[:status]}    #{task[:version]}  #{task[:task_name].capitalize}"
    end
  end

  namespace :pretask do
    desc "runs (in order) all pending after_party pre-deployment tasks, if they have not run yet against the current db."
    task :run => :environment do
      tasks = AfterParty::TaskRecorder.pending_pretask_files.map {|f| "after_party:#{f.task_name}"}

      tasks.each {|t| Rake::Task[t].invoke}

      if tasks.empty?
        puts "no pending tasks to run"
      end

    end

    desc "Check the status of after_party pre-deployment tasks"
    task :status => :environment do
      tasks = Dir[AfterParty::TaskRecorder::FILE_MASK].collect do |filename|
        recorder = AfterParty::TaskRecorder.new(filename)
        task_obj = {
          version: recorder.timestamp,
          task_name: recorder.task_name.humanize,
          status: recorder.pending? ? 'down' : ' up '
        }
        if AfterParty.enable_pretasks?
          recorder.post_task? ? nil : task_obj
        else
          nil
        end
      end.compact

      puts "Note: pretasks are not enabled.  set 'config.enable_pretasks = true' in the initializer to use pre-tasks" if !AfterParty.enable_pretasks?
      puts <<-EOF
Status   Task ID         Task Name
--------------------------------------------------
      EOF
      tasks.each do |task|
        puts " #{task[:status]}    #{task[:version]}  #{task[:task_name].capitalize}"
      end
    end

  end
end
