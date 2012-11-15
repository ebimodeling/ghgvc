class RemoveUsgsmuidFromSites < ActiveRecord::Migration
  def self.up
    remove_column :sites, :usgsmuid
  end

  def self.down
    add_column :sites, :usgsmuid, :string
  end
end
