namespace :deployment do
  task :run_deploy_tasks => :environment do
    require File.join(Rails.root, 'lib/deploy_task_file.rb')
    tasks = DeployTaskFile.pending_files.map {|f| "deployment:#{f.task_name}"}

    tasks.each {|t| Rake::Task[t].invoke}

    if tasks.empty?
      puts "no pending tasks to run"
    end

  end
end
