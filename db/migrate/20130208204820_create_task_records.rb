class CreateTaskRecords < ActiveRecord::Migration
  def change
    create_table :task_records, :id => false do |t|
      t.string :version, :null => false
    end
  end
end