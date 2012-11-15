class AddCountryToLocationYields < ActiveRecord::Migration
  def self.up
    add_column :location_yields, :country, :string
  end

  def self.down
    remove_column :location_yields, :country
  end
end
