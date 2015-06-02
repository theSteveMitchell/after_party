module AfterParty
  class TaskRecord
    include Mongoid::Document
    include Mongoid::Timestamps

    field :version, type: String


    def self.completed_task?(version)
      all.any?{|t| t.version == version}
    end
  end
end

