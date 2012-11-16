class RemoveCensusidFromCountyBoundary < ActiveRecord::Migration
  def self.up
    remove_column :county_boundaries, :censusid
    remove_column :counties, :censusid
  end

  def self.down
    add_column :county_boundaries, :censusid, :integer
    add_column :counties, :censusid, :integer
    add_index :county_boundaries, :censusid
  end
end
