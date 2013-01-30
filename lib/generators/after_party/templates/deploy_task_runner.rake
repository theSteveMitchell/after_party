namespace :deployment do
  task :run_deploy_tasks => :environment do
    require File.join(Rails.root, 'lib/data_version_file.rb')
    tasks = DataVersionFile.pending_files.map {|f| "deployment:#{f.task_name}"}

    tasks.each {|t| Rake::Task[t].invoke}

    if tasks.empty?
      puts "no pending tasks to run"
    end

  end
end
