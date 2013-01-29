namespace :deployment do

    desc "<%= task_description %>"
    task :<%= file_name %> => :environment do
      puts "running deployment task '<%= file_name %>'"

      # put your task implementation here
      
      # update task as completed
      DeployTask.create :version => '<%= timestamp %>'
    end

end
