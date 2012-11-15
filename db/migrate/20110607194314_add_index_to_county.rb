class AddIndexToCounty < ActiveRecord::Migration
  def self.up

#    add_index :county_boundaries, :lat
#    add_index :county_boundaries, :lng
    add_index :county_boundaries, :censusid
    add_index :location_yields, [:location,:species]

  end

  def self.down

#    remove_index :county_boundaries, :lat
#    remove_index :county_boundaries, :lng
    remove_index :county_boundaries, :censusid
    remove_index :location_yields, [:location,:species]

  end
end
