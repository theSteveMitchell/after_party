module AfterParty
  # Task Record is a persisted object recorded when a taks is run.
  class TaskRecord < ActiveRecord::Base
    attr_accessible :version if ::Rails::VERSION::MAJOR.to_i == 3

    def self.completed_task?(version)
      all.any? { |t| t.version == version }
    end

    def self.record_task_run(filename)
      create(version: AfterParty::TaskRecorder.new(filename).timestamp)
    end
  end
end