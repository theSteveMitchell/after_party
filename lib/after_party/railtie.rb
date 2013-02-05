require 'after_party'
require 'rails'
module AfterParty
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir.glob('tasks/*.rake').each { |r| import r }
    end
  end
end