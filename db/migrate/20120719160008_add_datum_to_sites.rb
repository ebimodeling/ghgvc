class AddDatumToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :datum, :string
  end

  def self.down
    remove_column :sites, :datum
  end
end
