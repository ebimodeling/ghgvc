class AddIndexToCountyForeignKeys < ActiveRecord::Migration
  def self.up
    add_index :county_boundaries, :county_id
    add_index :location_yields, :county_id
  end

  def self.down
    remove_index :county_boundaries, :county_id
    remove_index :location_yields, :county_id
  end
end
