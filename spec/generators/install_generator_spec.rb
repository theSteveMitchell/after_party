require "spec_helper"

describe AfterParty::Generators::InstallGenerator do

require "generator_spec/test_case"

include GeneratorSpec::TestCase
destination File.expand_path("../../tmp", __FILE__)
arguments %w(active_record)

  context "with active_record" do
    before(:all) do
      prepare_destination
      run_generator
    end

    it "creates an initializer" do
      assert_file "config/initializers/after_party.rb", /require "after_party\/active_record.rb"/
    end

    it "creates the migration file " do
      assert_migration "db/migrate/create_task_records.rb", /def change/
    end

    it "creates the migration with plural table name if pluralization is on " do
      #it's on by default, brah
      assert_migration "db/migrate/create_task_records.rb", /create_table :task_records, :id => false do |t|/
    end


  end

  context "with active_record singular table names" do
    before(:all) do
      prepare_destination
      ActiveRecord::Base.pluralize_table_names = false
      run_generator
    end

    after(:all) do
      ActiveRecord::Base.pluralize_table_names = true
    end

    it "creates the migration with singular table name if pluralization is off " do
      assert_migration "db/migrate/create_task_record.rb", /create_table :task_record, :id => false do |t|/
    end

  end

end

describe AfterParty::Generators::InstallGenerator do

  require "generator_spec/test_case"

  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)
  arguments %w(mongoid)

  context "with mongoid" do
    before(:all) do
      prepare_destination

      run_generator
    end

    it "creates an initializer for mongoid" do
      assert_file "config/initializers/after_party.rb", /require "after_party\/mongoid.rb"/
    end

    it "creates no migration file " do
      assert_no_migration "db/migrate/create_task_records.rb"
    end
  end
end