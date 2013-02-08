require 'rails/generators'

module AfterParty
  module Generators

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_initializer_file
        create_file "config/initializers/after_party.rb", "# Welcome to the party!"
      end

      def copy_migration
        unless migration_exists?
          template "migration.rb", "db/migrate/#{timestamp}_create_data_versions.rb"
        end
      end

      private
      def timestamp
        @timestamp ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def migration_exists?
        Dir.glob("/db/migrate/[0-9]*_create_data_versions.rb").first
      end
    end
  end
end