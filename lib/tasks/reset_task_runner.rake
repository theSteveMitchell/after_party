namespace :after_party do

  # Use this task if you want to clear the table that After Party uses to track
  # the tasks that have already been run.  This allows you to execute rake after_party:run
  # and re-run all of the tasks (which is useful in development).

  desc "resets the database so all tasks can be run again"
  task :reset => :environment do

    TaskRecord.delete_all
    puts (TaskRecord.count == 0 ? "Success!  You may now rerun all tasks using 'rake after_party:run'" : "There was a problem during the reset (the task_record table should be empty, but it is not).")
    
  end
end
