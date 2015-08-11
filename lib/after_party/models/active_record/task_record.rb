class TaskRecord < ActiveRecord::Base
  if ::Rails::VERSION::MAJOR.to_i == 3
    attr_accessible :version
  end
  
  def self.completed_task?(version)
    all.any?{|t| t.version == version}
  end

end
