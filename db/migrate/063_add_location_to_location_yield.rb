class AddLocationToLocationYield < ActiveRecord::Migration
  def self.up
    add_column :location_yields, :location, :string
  end

  def self.down
    remove_column :location_yields, :location
  end
end
