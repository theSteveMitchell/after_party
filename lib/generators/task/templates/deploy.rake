namespace :after_party do

    desc "<%= task_description %>"
    task :<%= file_name %> => :environment do
      Dir[Rails.root.join("lib/after_party/*.rb")].each {|f| require f}
      puts "running deploy task '<%= file_name %>'"

      # put your task implementation here
      
      # update task as completed.  If you remove the line below, the task will run with every deploy (or every time you call after_party:run)
      DataVersion.create :version => '<%= timestamp %>'
    end

end
