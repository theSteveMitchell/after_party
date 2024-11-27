# frozen_string_literal: true

if ActiveRecord::VERSION::MAJOR >= 5
  class CreateTaskRecords < ActiveRecord::Migration[4.2]
    def change
      create_table :task_records, id: false do |t|
        t.string :version, null: false
      end
    end
  end

else
  class CreateTaskRecords < ActiveRecord::Migration
    def change
      create_table :task_records, id: false do |t|
        t.string :version, null: false
      end
    end
  end
end
