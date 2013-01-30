namespace :after_party do
  task :run => :environment do
    Dir[Rails.root.join("lib/after_party/*.rb")].each {|f| require f}
    tasks = DataVersionFile.pending_files.map {|f| "after_party:#{f.task_name}"}

    tasks.each {|t| Rake::Task[t].invoke}

    if tasks.empty?
      puts "no pending tasks to run"
    end

  end
end
