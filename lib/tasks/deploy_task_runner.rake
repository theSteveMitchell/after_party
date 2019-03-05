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
    tasks = Dir[AfterParty::TaskRecorder::FILE_MASK].sort.collect do |filename|
      recorder = AfterParty::TaskRecorder.new(filename)
      {
        version: recorder.timestamp,
        task_name: recorder.task_name.humanize,
        status: recorder.pending? ? 'down' : ' up '
      }
    end

    puts <<-EOF
Status   Task ID         Task Name
--------------------------------------------------
    EOF
    tasks.each do |task|
      puts " #{task[:status]}    #{task[:version]}  #{task[:task_name].capitalize}"
    end
  end
end
