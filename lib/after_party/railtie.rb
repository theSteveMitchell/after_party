require 'after_party'
require 'rails'
module AfterParty
  class Railtie < Rails::Railtie
    #railtie is loaded from lib/after_party.rb.  So all load paths need to be relative to /lib
    rake_tasks do
      load "tasks/deploy_task_runner.rake"
    end

    initializer "load_task_record_models" do
      load "after_party/models/task_recorder.rb"
    end

    generators do
      load "generators/task/task_generator.rb"
      load "generators/install/install_generator.rb"
    end
  end


end
