require 'date'

module AfterParty
  module Generators
    # creates after_party tasks
    class TaskGenerator < Rails::Generators::Base
      source_root(File.expand_path('../templates', __FILE__))
      argument(:name, type: :string)
      class_option(
        :description,
        type: :string,
        description: 'Include a description'
      )
      class_option(
        :test,
        type: :boolean
        description: 'Generate a rspec test for task'
      )

      def copy_deploy_task
        template(
          'deploy.txt.erb',
          "lib/tasks/deployment/#{timestamp}_#{file_name}.rake"
        )
        generate 'after_party_test' if options.test
      end

      private

      def file_name
        name.underscore
      end

      def task_description
        line = 'Deployment task: '
        return line + file_name if options.description.blank?

        line + options.description
      end

      def timestamp
        @timestamp ||= Time.now.utc.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end
