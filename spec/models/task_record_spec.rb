require 'spec_helper'
require 'fileutils'

module AfterParty
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
      list = AfterParty::TaskRecorder.pending_files
      expect(list.count).to eq(3)

      expect(list.first.filename).to match /20120205141454_m_three.rake/
      expect(list[1].filename).to match /20130205176456_z_first.rake/
      expect(list[2].filename).to match /20130207948264_a_second2.rake/
    end

    it "should not include tasks that have already been recorded in the database" do
      a = build :task_record, :version => "20120205141454"
      b = build :task_record, :version => "20130207948264"
      expect(AfterParty::TaskRecord).to receive(:all).at_least(:once).and_return([a, b])
      list = AfterParty::TaskRecorder.pending_files
      expect(list.count).to eq(1)
      expect(list.first.filename).to match /20130205176456_z_first.rake/

    end


  end
end
