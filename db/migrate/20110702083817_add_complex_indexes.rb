class AddComplexIndexes < ActiveRecord::Migration
  def self.up
    add_index :location_yields, [:species, :county_id]
  end

  def self.down
    remove_index :location_yields, [:species, :county_id]
  end
end
