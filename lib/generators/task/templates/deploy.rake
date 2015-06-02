namespace :after_party do

    desc "<%= task_description %>"
    task :<%= file_name %> => :environment do
      after_party do
        
        
      end

      puts "running deploy task '<%= file_name %>'"

      # put your task implementation here
      
      # update task as completed.  If you remove the line below, the task will run with every deploy (or every time you call after_party:run)
      AfterParty::TaskRecord.create :version => '<%= timestamp %>'
    end

end
