# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'

module AfterParty
  describe TaskRecorder do
    include FileUtils

    before(:all) do
      file_path = File.join(Rails.root, 'spec/fixtures/tasks/deployment/')
      silence_warnings do
        TaskRecorder::FILE_MASK = File.join(file_path, '/*.rake')
      end
    end

    describe 'pending_files' do
      context 'when no tasks have been completed' do
        it 'should return an ordered list of all tasks' do
          list = TaskRecorder.pending_files
          expect(list.count).to eq 3

          expect(list.first.filename).to match(/20120205141454_m_three.rake/)
          expect(list[1].filename).to match(/20130205176456_z_first.rake/)
          expect(list[2].filename).to match(/20130207948264_a_second2.rake/)
        end
      end

      context 'When some tasks have been completed' do
        before(:all) do
          create :task_record, version: '20120205141454'
          create :task_record, version: '20130207948264'
        end

        after(:all) do
          TaskRecord.delete_all
        end

        it 'should not include tasks that have already been recorded in the database' do
          list = TaskRecorder.pending_files
          expect(list.count).to eq 1
          expect(list[0].filename).to match(/20130205176456_z_first.rake/)
        end
      end
    end
  end
end
