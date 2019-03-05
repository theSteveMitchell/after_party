require "spec_helper"
require "rake"
require "fileutils"


describe "rake after_party:status" do
  include FileUtils

  context "Given we have both ran tasks and tasks to run" do
    before do
      AfterParty::Application.load_tasks

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
        AfterParty::TaskRecorder::FILE_MASK = File.join(FILE_PATH, "/*.rake")
      end

      a = FactoryBot.build :task_record, :version => "20120205141454"
      b = FactoryBot.build :task_record, :version => "20130207948264"
      allow(AfterParty::TaskRecord).to receive(:all) { [a, b] }
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
end
