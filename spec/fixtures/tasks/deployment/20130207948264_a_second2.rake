namespace :after_party do
  desc 'Deployment task: a_description_of_said_task'
  task a_second2: :environment do
    # Put your task implementation HERE.

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord.record_task_run(__FILE__)
  end
end