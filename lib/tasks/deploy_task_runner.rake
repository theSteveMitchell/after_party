namespace :after_party do
  desc "runs (in order) all pending after_party deployment tasks, if they have not run yet against the current db."
  task :run => :environment do
    tasks = AfterParty::TaskRecorder.pending_files.map {|f| "after_party:#{f.task_name}"}

    tasks.each {|t| Rake::Task[t].invoke}

    if tasks.empty?
      puts "no pending tasks to run"
    end

  end
end
