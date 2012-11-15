class AddFipsToCounty < ActiveRecord::Migration
  def self.up
    add_column :counties, :state_fips, :integer
    add_column :counties, :county_fips, :integer
  end

  def self.down
    remove_column :counties, :county_fips
    remove_column :counties, :state_fips
  end
end
