require "spec_helper"
require "rake"
require "fileutils"


describe "rake after_party:status" do
  include FileUtils

  before(:each) do
    silence_warnings do
      FILE_PATH = File.join(Rails.root, "spec/tmp/lib/tasks/deployment/")
    end

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
    File.open(File.join(FILE_PATH, "20120105141454_pretask_four.rake"), "w+") do |f|
      f.write("this is some contents for file 4")
    end
    silence_warnings do
      AfterParty::TaskRecorder::FILE_MASK = File.join(FILE_PATH, "/*.rake")
    end
  end

  before(:each) do
    AfterParty::Application.load_tasks
    a = FactoryGirl.build :task_record, :version => "20120205141454"
    b = FactoryGirl.build :task_record, :version => "20130207948264"
    allow(AfterParty::TaskRecord).to receive(:all) { [a, b] }
  end

  after(:each) do
    Rake.application.clear
  end

  context "Given we have both pending and ran tasks, and pretasks disabled" do
    before do
      AfterParty.enable_pretasks = false
    end

    it "should output all the tasks" do
      expected_output = <<-EOF
Status   Task ID         Task Name
--------------------------------------------------
 down    20120105141454  Pretask four
  up     20120205141454  M three
 down    20130205176456  Z first
  up     20130207948264  A second2
      EOF

      expect { Rake::Task["after_party:status"].invoke }.to output(/#{expected_output}/).to_stdout
    end
  end

  context "Given we have both ran tasks and tasks to run with pretasks enabled" do
    before do
      AfterParty.enable_pretasks = true
    end

    it "should output the proper output" do
      expected_output = <<-EOF
Status   Task ID         Task Name
--------------------------------------------------
  up     20120205141454  M three
 down    20130205176456  Z first
  up     20130207948264  A second2
      EOF
      expect { Rake::Task["after_party:status"].invoke }.to output(/#{expected_output}/).to_stdout
    end
  end

  context "Given we have pretasks left to run" do
    before do
      AfterParty.enable_pretasks = true
    end

    it "should output the proper output" do
      expected_output = <<-EOF
Status   Task ID         Task Name
--------------------------------------------------
 down    20120105141454  Pretask four
      EOF
      expect { Rake::Task["after_party:pretask:status"].invoke }.to output(/#{expected_output}/).to_stdout
    end
  end

end
