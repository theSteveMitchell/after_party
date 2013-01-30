class CreateDataVersions < ActiveRecord::Migration
  def change
    create_table :data_version, :id => false do |t|
      t.string :version, :null => false
    end
  end
end