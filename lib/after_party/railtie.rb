require 'after_party'
require 'after_party'
require 'rails'
module AfterParty
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/deploy_task_runner.rake"
    end

    initializer "load_data_version_models" do
      if defined? Mongoid
        load "models/mongoid/data_version.rb"
      else
        load "models/active_record/data_version.rb"
      end
      load "models/data_version_file.rb"
    end

    generators do
      load "generators/task_generator.rb"
      load "generators/install_generator.rb"
    end
  end


end