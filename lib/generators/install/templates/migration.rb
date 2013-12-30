class CreateTaskRecords < ActiveRecord::Migration
  def change
    create_table :<%= table_name %>, :id => false do |t|
      t.string :version, :null => false
    end
  end
end