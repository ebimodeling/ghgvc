class AddFieldsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :local_time, :integer
    add_column :sites, :sand_pct, :decimal, :precision => 9, :scale => 5
    add_column :sites, :clay_pct, :decimal, :precision => 9, :scale => 5
  end
  def self.down
    remove_column :sites, :local_time
    remove_column :sites, :sand_pct
    remove_column :sites, :clay_pct
  end
end
