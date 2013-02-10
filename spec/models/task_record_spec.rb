require 'spec_helper'
require 'fileutils'

Dir[Rails.root.join("lib/after_party/models/*.rb")].each {|f| require f}
Dir[Rails.root.join("lib/after_party/models/active_record/*.rb")].each {|f| require f}

describe TaskRecord do
  include FileUtils

  before(:all) do

    FILE_PATH = File.join(Rails.root, "spec/tmp/lib/tasks/deployment/")
    rm_rf(FILE_PATH)
    mkdir_p(FILE_PATH)
    File.open(File.join(FILE_PATH, "20130205176456_z_first.rake"), "w+") do |f|
      f.write("this is some contents for file 1")
    end
    File.open(File.join(FILE_PATH, "20130207948264_a_second2.rake"), "w+") do |f|
      f.write("this is some contents for file 2")
    end
    File.open(File.join(FILE_PATH, "20120205141454_m_three.rake"), "w+") do |f|
      f.write("this is some contents for file 3")
    end
    silence_warnings do
      TaskRecorder::FILE_MASK = File.join(FILE_PATH, "/*.rake")
    end

  end

  it "should return an ordered list of pending tasks" do
    list = TaskRecorder.pending_files
    list.count.should == 3

    list.first.filename.should =~ /20120205141454_m_three.rake/
    list[1].filename.should =~ /20130205176456_z_first.rake/
    list[2].filename.should =~ /20130207948264_a_second2.rake/
  end

  it "should not include tasks that have already been recorded in the database" do
    a = build :task_record, :version => "20120205141454"
    b = build :task_record, :version => "20130207948264"
    TaskRecord.stub(:all).and_return([a, b])
    list = TaskRecorder.pending_files
    list.count.should == 1
    list.first.filename.should =~ /20130205176456_z_first.rake/

  end


end