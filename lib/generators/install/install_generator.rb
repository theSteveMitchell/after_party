require 'rails/generators'

module AfterParty
  module Generators

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :orm_name, :type => :string, :default => "active_record"


      def create_initializer_file
        template "after_party.rb", "config/initializers/after_party.rb"
      end

      def copy_migration
        if requires_migration?
          template "migration.rb", "db/migrate/#{timestamp}_create_task_records.rb"
        end
      end

      private
      def timestamp
        @timestamp ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def migration_exists?
        absolute = File.expand_path("db/migrate/", destination_root)
        #dirname, file_name = File.dirname(absolute), File.basename(absolute).sub(/\.rb$/, '')
        Dir.glob("#{absolute}/[0-9]*_create_task_records.rb").first
      end

      def requires_migration?
        orm_name == "active_record" && !migration_exists?
      end

    end
  end
end