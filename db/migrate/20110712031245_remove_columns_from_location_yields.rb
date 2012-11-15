class RemoveColumnsFromLocationYields < ActiveRecord::Migration
  def self.up
    remove_column :location_yields, :lat
    remove_column :location_yields, :lon
    remove_column :location_yields, :location
    remove_column :location_yields, :country
  end

  def self.down
    add_column :location_yields, :country, :string
    add_column :location_yields, :location, :string
    add_column :location_yields, :lon, :decimal, :precision => 20, :scale => 15
    add_column :location_yields, :lat, :decimal, :precision => 20, :scale => 15
  end
end
