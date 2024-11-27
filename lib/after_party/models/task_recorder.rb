# frozen_string_literal: true

module AfterParty
  # Task Recorder is responsible for collecting pending tasks and recording their execution
  class TaskRecorder
    include ActiveModel::Naming
    attr_reader :filename, :timestamp, :task_name

    FILE_MASK = File.join(Rails.root, 'lib/tasks/deployment/*.rake')

    def self.pending_files
      Dir[FILE_MASK].collect { |f| TaskRecorder.new(f) }
                    .select(&:pending?)
                    .sort_by(&:timestamp)
    end

    def initialize(filename = '')
      @filename = filename
      parse_filename
    end

    def pending?
      timestamp && !TaskRecord.completed_task?(timestamp)
    end

    def parse_filename
      /(\d+)_(.+)\.rake/.match(Pathname(@filename).basename.to_s) do |m|
        @timestamp = m[1]
        @task_name = m[2]
      end
    end
  end
end
