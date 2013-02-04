require 'date'
module AfterParty
  module Generators
    class TaskGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      argument :name, :type => :string
      argument :description, :type => :string, :default => :nil

      def copy_deploy_task

        template "deploy.rake",  "lib/tasks/deployment/#{timestamp}_#{file_name}.rake"

      end

      private
      def file_name
        name.underscore.tr(" ", "_")
      end

      def task_description
        "Deployment task: #{description || file_name}"
      end

      def timestamp
        @timestamp ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
