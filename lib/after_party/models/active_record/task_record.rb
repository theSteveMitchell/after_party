module AfterParty
  class TaskRecord < ActiveRecord::Base
    def self.completed_task?(version)
      all.any?{|t| t.version == version}
    end
  end
end
