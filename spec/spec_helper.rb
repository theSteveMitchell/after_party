# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'factory_bot'

Dir[Rails.root.join('lib/after_party/models/*.rb')].each { |f| require f }
Dir[Rails.root.join('lib/after_party/models/active_record/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/factories/*.rb')].each { |f| require f }

Dir[Rails.root.join('lib/*.rb')].each { |f| require f }
Dir[Rails.root.join('lib/generators/install/*.rb')].each { |f| require f }
Dir[Rails.root.join('lib/generators/task/*.rb')].each { |f| require f }

if ActiveRecord::VERSION::MAJOR >= 5
  ActiveRecord::Migration.migrate(File.join(Rails.root, 'db/migrate'))
else
  ActiveRecord::Migrator.migrate(File.join(Rails.root, 'db/migrate'))
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include FactoryBot::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
