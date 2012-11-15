class AddSiteName < ActiveRecord::Migration
  def self.up
    add_column :sites, :sitename, :string
  end

  def self.down
    remove_column :sites, :sitename
  end
end
