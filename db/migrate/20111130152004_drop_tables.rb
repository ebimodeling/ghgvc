class DropTables < ActiveRecord::Migration
  def self.up
    drop_table :visitors
    drop_table :county_boundaries
    drop_table :county_paths
    drop_table :plants
    drop_table :drop_me
  end

  def self.down
  end
end
