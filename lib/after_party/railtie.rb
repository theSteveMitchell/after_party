require 'after_party'
require 'rails'
module AfterParty
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/deploy_task_runner.rake"
    end
  end
end