class CreateDataVersions < ActiveRecord::Migration
  def change
    create_table :data_versions, :id => false do |t|
      t.string :version, :null => false
    end
  end
end