class AddCountyToLocationYields < ActiveRecord::Migration
  def self.up
    add_column :location_yields, :county_id, :integer
  end

  def self.down
    remove_column :location_yields, :county_id
  end
end
