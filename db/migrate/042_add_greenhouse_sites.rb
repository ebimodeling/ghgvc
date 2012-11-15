class AddGreenhouseSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :greenhouse, :boolean
  end

  def self.down
    remove_column :sites, :greenhouse
  end
end
