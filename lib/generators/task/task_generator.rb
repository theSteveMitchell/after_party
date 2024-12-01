# frozen_string_literal: true

require 'date'

module AfterParty
  module Generators
    # creates after_party tasks
    class TaskGenerator < Rails::Generators::Base
      FILE_MASK = File.join(Rails.root, 'lib/tasks/deployment/*.rake')
      source_root(File.expand_path('templates', __dir__))
      argument(:name, type: :string)
      class_option(
        :description,
        type: :string,
        description: 'Include a description'
      )

      def copy_deploy_task
        file_names = Dir[FILE_MASK].collect { |f| AfterParty::TaskRecorder.new(f) }.map { |f| f.task_name.to_s }
        if file_names.include?(file_name)
          puts 'Error: Please Create a unique task name'
        else
          template(
            'deploy.txt.erb',
            "lib/tasks/deployment/#{timestamp}_#{file_name}.rake"
          )
        end
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
