# frozen_string_literal: true

require 'rails/generators'

module AfterParty
  module Generators
    # Generates the after_party.rb in config/initializers and a migration file
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      argument :orm_name, type: :string, default: 'active_record'

      def create_initializer_file
        template 'after_party.txt.erb', 'config/initializers/after_party.rb'
      end

      def copy_migration
        return unless requires_migration?

        if requires_version_tag?
          template 'migration.txt.erb', "db/migrate/#{timestamp}_create_#{table_name}.rb"
        else
          template 'migration-rails-3-4.txt.erb', "db/migrate/#{timestamp}_create_#{table_name}.rb"
        end
      end

      def requires_version_tag?
        ActiveRecord::VERSION::MAJOR >= 5
      end

      private

      def timestamp
        @timestamp ||= Time.now.utc.strftime('%Y%m%d%H%M%S')
      end

      def migration_exists?
        absolute = File.expand_path('db/migrate/', destination_root)
        Dir.glob("#{absolute}/[0-9]*_create_#{table_name}.rb").first
      end

      def rails_version_for_migration
        "#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"
      end

      def requires_migration?
        orm_name == 'active_record' && !migration_exists?
      end

      def table_name
        table = 'task_record'
        ActiveRecord::Base.pluralize_table_names ? table.pluralize : table
      end
    end
  end
end
