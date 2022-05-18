# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec/test_case'

describe AfterParty::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __dir__)

  context 'with active_record' do
    arguments %w[active_record]

    before(:all) do
      prepare_destination
      run_generator
    end

    it 'creates an initializer' do
      assert_file 'config/initializers/after_party.rb', %r{require 'after_party/active_record.rb'}
    end

    it 'creates the migration file ' do
      assert_migration 'db/migrate/create_task_records.rb', /def change/
    end

    it 'creates the migration with plural table name if pluralization is on ' do
      # it's on by default.
      assert_migration 'db/migrate/create_task_records.rb', /create_table :task_records, :id => false do |t|/
    end

    context 'under rails 5' do
      it 'copies the template with rails 5 compatible migrations' do
        allow_any_instance_of(AfterParty::Generators::InstallGenerator)
          .to receive(:requires_version_tag?).and_return(true)
        allow_any_instance_of(AfterParty::Generators::InstallGenerator)
          .to receive(:rails_version_for_migration).and_return('20.7')

        prepare_destination
        run_generator

        assert_migration 'db/migrate/create_task_records.rb', /class CreateTaskRecords < ActiveRecord::Migration\[20.7\]\n/
      end
    end

    context 'under rails 3' do
      it 'copies the template with rails 3/4 compatible migrations' do
        allow_any_instance_of(AfterParty::Generators::InstallGenerator).to receive(:requires_version_tag?).and_return(false)
        prepare_destination
        run_generator

        assert_migration 'db/migrate/create_task_records.rb', /class CreateTaskRecords < ActiveRecord::Migration\n/
      end
    end

    context 'with active_record singular table names' do
      before(:all) do
        prepare_destination
        ActiveRecord::Base.pluralize_table_names = false
        run_generator
      end

      after(:all) do
        ActiveRecord::Base.pluralize_table_names = true
      end

      it 'creates the migration with singular table name if pluralization is off ' do
        assert_migration 'db/migrate/create_task_record.rb', /create_table :task_record, :id => false do |t|/
      end
    end
  end
end

describe AfterParty::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __dir__)

  context 'with mongoid' do
    arguments %w[mongoid]

    before(:all) do
      prepare_destination

      run_generator
    end

    it 'creates an initializer for mongoid' do
      assert_file 'config/initializers/after_party.rb', %r{require 'after_party/mongoid.rb'}
    end

    it 'creates no migration file ' do
      assert_no_migration 'db/migrate/create_task_records.rb'
    end
  end
end
