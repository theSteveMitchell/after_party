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
    puts <<-EOF
Status   Task ID         Task Name
--------------------------------------------------
  up     20120205141454  M three
  up     20130207948264  A second2
 down    20130205176456  Z first
    EOF
  end
end
