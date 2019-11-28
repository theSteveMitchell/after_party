module AfterParty
  # Task Record is a persisted object recorded when a taks is run.
  class TaskRecord
    include Mongoid::Document
    include Mongoid::Timestamps

    field :version, type: String

    def self.completed_task?(version)
      all.any? { |t| t.version == version }
    end

    def self.record_task_run(filename)
      create(version: AfterParty::TaskRecorder.new(filename).timestamp)
    end
  end
end