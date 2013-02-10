class TaskRecord < ActiveRecord::Base
  attr_accessible :version

  def self.completed_task?(version)
    all.any?{|t| t.version == version}
  end

end
