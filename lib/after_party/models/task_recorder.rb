

class TaskRecorder
  include ActiveModel::Naming
  attr_reader :filename, :timestamp, :task_name

  FILE_MASK = File.join(Rails.root, "lib/tasks/deployment/*.rake")

  def self.pending_files
    Dir[FILE_MASK].collect{ |f| TaskRecorder.new(f) }.select{ |f| f.pending? }.sort{ |x,y| x.timestamp <=> y.timestamp }
  end

  def initialize(filename='')
    @filename = filename
    parse_filename
  end

  def pending?
      timestamp && !TaskRecord.completed_task?(timestamp)
  end

  def parse_filename
    /(\d+)_(.+)\.rake/.match(Pathname(@filename).basename.to_s)
    @timestamp = $1
    @task_name = $2
  end
end
