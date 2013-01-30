namespace :after_party do

    desc "<%= task_description %>"
    task :<%= file_name %> => :environment do
      puts "running deploy task '<%= file_name %>'"

      # put your task implementation here
      
      # update task as completed
      DataVersion.create :version => '<%= timestamp %>'
    end

end
